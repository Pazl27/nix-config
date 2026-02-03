{
  config,
  lib,
  pkgs,
  ...
}:
{
  # ============================================
  # SYSTEM SETTINGS
  # ============================================
  system.defaults = {
    # === DOCK ===
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.5;
      orientation = "bottom";
      show-recents = false;
      tilesize = 48;
      minimize-to-application = true;
      mru-spaces = false;
    };

    # === FINDER ===
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = false;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv"; # List view
      _FXShowPosixPathInTitle = true;
    };

    # === TRACKPAD ===
    trackpad = {
      Clicking = true; # Tap to click
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = false;
    };

    # === KEYBOARD ===
    NSGlobalDomain = {
      # Keyboard
      ApplePressAndHoldEnabled = false; # Key repeat instead of accents
      InitialKeyRepeat = 15;
      KeyRepeat = 2;

      # General UI
      AppleShowAllExtensions = true;
      AppleInterfaceStyle = "Dark";

      # Disable auto-correct annoyances
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };

    # === LOGIN WINDOW ===
    loginwindow = {
      GuestEnabled = false;
    };

    # === SCREENSHOTS ===
    screencapture = {
      location = "~/Pictures/Screenshots";
      type = "png";
    };
  };

  # ============================================
  # KEYBOARD SETTINGS
  # ============================================
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = false;
  };

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

  # ============================================
  # SERVICES
  # ============================================
  services.nix-daemon.enable = true;

  # ============================================
  # STATE VERSION
  # ============================================
  system.stateVersion = 5;
}