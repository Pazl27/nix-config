# Declarative apps: one `services.homelab.apps.<name>` entry becomes a
# sandboxed, resource-limited podman container (`podman-<name>.service`).
#
# The image is either built from a Nix package (no Dockerfile, no base
# distro) or pulled from a registry. `secrets.sops.file` is the only part
# that needs sops-nix; leave it null and no secrets are involved.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption mkEnableOption types;
  enabled = lib.filterAttrs (_: app: app.enable) config.services.homelab.apps;
  secretName = name: "homelab-${name}";
in
{
  options.services.homelab.apps = mkOption {
    default = { };
    description = "Apps to run as containers on this host.";
    type = types.attrsOf (
      types.submodule (
        { name, config, ... }:
        {
          options = {
            enable = mkEnableOption name;

            package = mkOption {
              type = types.nullOr types.package;
              default = null;
              description = "Package baked into a Nix-built image. Set this or `image`.";
            };

            image = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "docker.io/louislam/uptime-kuma:1.23.16@sha256:…";
              description = "Registry image (pin it by digest). Set this or `package`.";
            };

            cmd = mkOption {
              type = types.listOf types.str;
              default = lib.optional (config.package != null) (lib.getExe config.package);
              defaultText = "[ (lib.getExe package) ]";
              description = "Command to run; overrides the image's default for registry images.";
            };

            network = {
              ports = mkOption {
                type = types.attrsOf types.port;
                default = { };
                example = {
                  http = 3000;
                  metrics = 9100;
                };
                description = "Named ports, published on `address` under the same number.";
              };

              address = mkOption {
                type = types.str;
                default = "127.0.0.1";
                description = ''
                  Host address the ports are published on. Published ports bypass
                  `networking.firewall`, so "0.0.0.0" makes them reachable on the LAN.
                '';
              };
            };

            environmentVariables = mkOption {
              type = types.attrsOf types.str;
              default = { };
              description = "Plain environment variables (they end up in the Nix store).";
            };

            secrets.sops.file = mkOption {
              type = types.nullOr types.path;
              default = null;
              example = lib.literalExpression "../../secrets/my-app.env";
              description = ''
                sops-encrypted dotenv file (`sops secrets/my-app.env`), decrypted on
                the host and passed to the container as environment variables.
              '';
            };

            volumes = mkOption {
              type = types.listOf types.str;
              default = [ ];
              example = [ "/var/lib/app:/data:U" ];
              description = "Volumes; add `:U` so podman chowns them to the container's mapped user.";
            };

            sandbox = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Read-only root fs, no capabilities, no privilege escalation and
                an unprivileged user namespace. Registry images that write to
                their own root fs may need this off.
              '';
            };

            # Named after the systemd directives, enforced by podman
            resources = {
              memoryMax = mkOption {
                type = types.str;
                default = "512M";
                description = "Memory limit, like systemd's MemoryMax.";
              };
              cpuQuota = mkOption {
                type = types.strMatching "[0-9]+%";
                default = "100%";
                description = "CPU time limit, like systemd's CPUQuota (200% = two cores).";
              };
              tasksMax = mkOption {
                type = types.ints.positive;
                default = 512;
                description = "Process/thread limit, like systemd's TasksMax.";
              };
            };
          };
        }
      )
    );
  };

  config = lib.mkIf (enabled != { }) {
    assertions = lib.mapAttrsToList (name: app: {
      assertion = (app.package == null) != (app.image == null);
      message = "services.homelab.apps.${name}: set exactly one of `package` or `image`.";
    }) enabled;

    sops.secrets = lib.concatMapAttrs (
      name: app:
      lib.optionalAttrs (app.secrets.sops.file != null) {
        ${secretName name} = {
          sopsFile = app.secrets.sops.file;
          format = "dotenv";
          key = ""; # whole file
          restartUnits = [ "podman-${name}.service" ];
        };
      }
    ) enabled;

    virtualisation.podman.enable = true;
    virtualisation.oci-containers.backend = "podman";
    virtualisation.oci-containers.containers = lib.mapAttrs (
      name: app:
      let
        # The package closure enters the image through the store paths in Cmd.
        stream = pkgs.dockerTools.streamLayeredImage {
          name = "homelab/${name}";
          contents = [ pkgs.cacert ];
          config = {
            Cmd = app.cmd;
            User = "65534:65534";
          };
        };
      in
      {
        image = if app.package != null then "${stream.imageName}:${stream.imageTag}" else app.image;
        imageStream = lib.mkIf (app.package != null) stream;
        cmd = lib.mkIf (app.image != null) app.cmd;
        ports = lib.mapAttrsToList (
          _: port: "${app.network.address}:${toString port}:${toString port}"
        ) app.network.ports;
        inherit (app) volumes;
        environment = app.environmentVariables;
        environmentFiles = lib.optional (
          app.secrets.sops.file != null
        ) config.sops.secrets.${secretName name}.path;
        extraOptions = [
          "--memory=${app.resources.memoryMax}"
          # CPUQuota=50% is 50ms of CPU per 100ms period
          "--cpu-quota=${toString (lib.toInt (lib.removeSuffix "%" app.resources.cpuQuota) * 1000)}"
          "--pids-limit=${toString app.resources.tasksMax}"
        ]
        ++ lib.optionals app.sandbox [
          "--read-only"
          "--cap-drop=all"
          "--security-opt=no-new-privileges"
          "--userns=auto"
        ];
      }
    ) enabled;


    # Bind mounts fail on missing host directories, so create them.
    systemd.tmpfiles.rules = lib.concatMap (
      app:
      map (v: "d ${lib.head (lib.splitString ":" v)} 0700 root root -") (
        lib.filter (lib.hasPrefix "/") app.volumes
      )
    ) (lib.attrValues enabled);

    # Container networking needs forwarding (security.nix defaults it to 0).
    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

    # --userns=auto maps each container onto an unprivileged UID range taken from this user.
    users.users.containers = {
      isSystemUser = true;
      group = "containers";
      subUidRanges = [
        {
          startUid = 2147483647;
          count = 2147483648;
        }
      ];
      subGidRanges = [
        {
          startGid = 2147483647;
          count = 2147483648;
        }
      ];
    };
    users.groups.containers = { };
  };
}
