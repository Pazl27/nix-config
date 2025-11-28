{
  config,
  lib,
  pkgs,
  host,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) virtualCamera;
in
{
  # ============================================
  # LOCALE & TIMEZONE
  # ============================================
  time.timeZone = lib.mkDefault "Europe/Berlin";

  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  i18n.extraLocaleSettings = lib.mkDefault {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # ============================================
  # KEYBOARD & INPUT
  # ============================================

  console.keyMap = lib.mkDefault "de";

  services.xserver = {
    xkb = {
      layout = lib.mkDefault "de";
      variant = lib.mkDefault "";
      options = lib.mkDefault "";
    };
  };

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
  # CPU Governor for better performance
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # Kernel parameters for better audio
  boot.kernelParams = [ "threadirqs" ];

  # ============================================
  # PRINTING
  # ============================================
  services.printing.enable = lib.mkDefault true;

  # ============================================
  # NIX SETTINGS
  # ============================================
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 30d";
  };

  # ============================================
  # ADDITIONAL USEFUL SETTINGS
  # ============================================
  services.fwupd.enable = lib.mkDefault true;
  services.fstrim.enable = lib.mkDefault true;

  # ============================================
  # OBS VIRTUAL CAMERA
  # ============================================
  programs.obs-studio.enableVirtualCamera = virtualCamera;
}
