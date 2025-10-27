{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  vm.guest-services.enable = true;
  drivers.intel.enable = true;

  networking.hostName = "nixvm";
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "Europe/Berlin";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
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

  # X11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "de";
      variant = "";
    };
  };

  # Desktop environments
  services.desktopManager.gnome.enable = true;
  programs.hyprland.enable = true;
  programs.niri.enable = true;

  # Console keymap
  console.keyMap = "de";

  # Printing
  services.printing.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User
  programs.zsh.enable = true;
  users.users.nixvm = {
    isNormalUser = true;
    description = "nix-vm";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Programs
  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  system.stateVersion = "25.05";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
