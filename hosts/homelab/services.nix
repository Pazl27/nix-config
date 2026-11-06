# Everything that runs on the homelab, in three kinds:
#
#   1. Apps:        one Nix package -> one sandboxed podman container
#                   (services.homelab.apps, options in modules/nixos/homelab.nix)
#   2. Stacks:      a repo whose flake exports nixosModules.default (e.g. prism),
#                   imported here and configured through its own options
#   3. Third-party: anything with a NixOS module (jellyfin, vaultwarden, ...),
#                   running natively as systemd units
#
# Updating something from another repo (added as a flake input in flake.nix):
#   nix flake update <input>   # pull its latest commit
#   nixos-rebuild switch …     # rebuild and restart what changed
{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # Default package of an app flake for this machine
  app = name: inputs.${name}.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  imports = [
    # === 2. Stacks ===
    # inputs.prism.nixosModules.default
  ];

  # services.prism = {
  #   enable = true;
  #   domain = "prism.example.de"; # the stack brings its own Caddy vhost
  # };

  # === 1. Apps ===
  services.homelab.apps = {
    whoami = {
      enable = true;
      package = pkgs.whoami;
      cmd = [
        (lib.getExe pkgs.whoami)
        "-port"
        "8080"
      ];
      network.ports.http = 8080;
      resources.memoryMax = "64M";
    };

    # my-app = {
    #   enable = true;
    #   package = app "my-app";
    #
    #   network.ports = {
    #     http = 3000;
    #     metrics = 3565;
    #   };
    #
    #   secrets.sops.file = ../../secrets/my-app.env;
    #
    #   environmentVariables = {
    #     PORT = "3000";
    #   };
    #
    #   volumes = [ "/var/lib/my-app:/data:U" ];
    #
    #   resources = {
    #     memoryMax = "256M";
    #     cpuQuota = "50%";
    #   };
    # };
  };

  # === 3. Third-party ===
  # services.jellyfin.enable = true; # web UI on 8096, state in /var/lib/jellyfin
  # systemd.services.jellyfin.serviceConfig = {
  #   MemoryMax = "2G";
  #   CPUQuota = "200%";
  # };
}
