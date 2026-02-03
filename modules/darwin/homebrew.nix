{
  config,
  lib,
  pkgs,
  ...
}:
{
  # ============================================
  # HOMEBREW CONFIGURATION
  # ============================================
  homebrew = {
    enable = true;

    # Auto-update Homebrew
    onActivation = {
      autoUpdate = true;
      cleanup = "zap"; # Remove unlisted packages
      upgrade = true;
    };

    # Homebrew taps
    taps = [
      "homebrew/bundle"
      "homebrew/services"
    ];

    # CLI tools from Homebrew (prefer nixpkgs when possible)
    brews = [
      # Add brews here if needed
    ];

    # GUI applications via Homebrew Cask
    casks = [
      # Add casks here if needed
    ];

    # Mac App Store apps (requires mas CLI)
    masApps = {
      # "App Name" = app_id;
    };
  };
}