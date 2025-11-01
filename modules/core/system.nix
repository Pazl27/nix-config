{
  config,
  lib,
  pkgs,
  ...
}:
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

  # Console keyboard layout
  console.keyMap = lib.mkDefault "de";

  # X11 keyboard layout
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

  # Disable PulseAudio (we use PipeWire)
  services.pulseaudio.enable = false;

  # Enable RealtimeKit (for low-latency audio)
  security.rtkit.enable = true;

  # PipeWire (modern audio server)
  services.pipewire = {
    enable = true;

    # ALSA support
    alsa = {
      enable = true;
      support32Bit = true;
    };

    # PulseAudio compatibility
    pulse.enable = true;

    # JACK support (optional, für professionelle Audio-Arbeit)
    jack.enable = lib.mkDefault false;
  };

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

    # Auto-optimize store
    auto-optimise-store = true;
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 30d";
  };

  # ============================================
  # ADDITIONAL USEFUL SETTINGS
  # ============================================

  # Enable firmware updates
  services.fwupd.enable = lib.mkDefault true;

  # Enable TRIM for SSDs
  services.fstrim.enable = lib.mkDefault true;
}
