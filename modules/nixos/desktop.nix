{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.features.desktop;
in
{
  options.features.desktop = {
    enable = mkEnableOption "desktop base (audio, printing, performance tweaks, desktop apps)" // {
      default = config.host.windowManager != null;
    };
  };

  config = mkIf cfg.enable {
    # ============================================
    # AUDIO
    # ============================================

    services.pulseaudio.enable = false;

    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = lib.mkDefault false;

      # Anti-crackling configuration
      extraConfig.pipewire = {
        "92-low-latency" = {
          context.properties = {
            default.clock.rate = 48000;
            default.clock.quantum = 1024;
            default.clock.min-quantum = 512;
            default.clock.max-quantum = 2048;
          };
        };
      };

      extraConfig.pipewire-pulse = {
        "92-low-latency" = {
          context.modules = [
            {
              name = "libpipewire-module-protocol-pulse";
              args = {
                pulse.min.req = "512/48000";
                pulse.default.req = "1024/48000";
                pulse.max.req = "2048/48000";
                pulse.min.quantum = "512/48000";
                pulse.max.quantum = "2048/48000";
              };
            }
          ];
          stream.properties = {
            node.latency = "1024/48000";
            resample.quality = 1;
          };
        };
      };
    };

    # Audio group limits for real-time performance
    security.pam.loginLimits = [
      {
        domain = "@audio";
        item = "memlock";
        type = "-";
        value = "unlimited";
      }
      {
        domain = "@audio";
        item = "rtprio";
        type = "-";
        value = "99";
      }
      {
        domain = "@audio";
        item = "nice";
        type = "-";
        value = "-11";
      }
    ];

    # ============================================
    # PERFORMANCE
    # ============================================
    # CPU Governor
    powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

    boot.kernelParams = [ "processor.max_cstate=1" ];

    # IRQ balancing for gaming
    services.irqbalance.enable = true;

    # === GAMING NETWORK OPTIMIZATIONS ===
    boot.kernel.sysctl = {
      "net.core.rmem_max" = 16777216;
      "net.core.wmem_max" = 16777216;
      "net.core.netdev_max_backlog" = 5000;
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_mtu_probing" = 1;
      "net.ipv4.tcp_fin_timeout" = 15;
    };

    # ============================================
    # FIREWALL
    # ============================================
    #  localsend
    networking.firewall = {
      allowedTCPPorts = [ 53317 ];
      allowedUDPPorts = [
        53317
        5353
      ];
    };

    # ============================================
    # DESKTOP SERVICES & APPS
    # ============================================
    services.printing.enable = lib.mkDefault true;
    services.gvfs.enable = true;

    programs.obs-studio.enableVirtualCamera = config.host.virtualCamera;

    environment.systemPackages = with pkgs; [
      chromium
      gnome-calculator
    ];
  };
}
