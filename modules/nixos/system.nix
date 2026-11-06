{ lib, ... }:
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
  # NETWORK
  # ============================================
  boot.kernelParams = [ "ipv6.disable=1" ]; # IPv6 is broken on the home network
  networking.enableIPv6 = false;

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
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # ============================================
  # ADDITIONAL USEFUL SETTINGS
  # ============================================
  services.fwupd.enable = lib.mkDefault true;
  services.fstrim.enable = lib.mkDefault true;
}
