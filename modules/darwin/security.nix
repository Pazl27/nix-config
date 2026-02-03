{
  config,
  lib,
  pkgs,
  ...
}:
{
  # ============================================
  # FIREWALL
  # ============================================
  security.pam.enableSudoTouchIdAuth = true;

  system.defaults.alf = {
    # Application Level Firewall
    globalstate = 1; # Enable firewall
    stealthenabled = 1; # Enable stealth mode
    allowsignedenabled = 1; # Allow signed apps
    allowdownloadsignedenabled = 1; # Allow downloaded signed apps
  };

  # ============================================
  # GATEKEEPER
  # ============================================
  system.defaults.LaunchServices = {
    LSQuarantine = true; # Enable quarantine for downloaded apps
  };

  # ============================================
  # NIX SETTINGS
  # ============================================
  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 0; Minute = 0; }; # Weekly on Sunday
    options = "--delete-older-than 30d";
  };

  nix.optimise.automatic = true;
}