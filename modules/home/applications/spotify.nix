{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  options.features.application.spotify.enable =
    mkEnableOption "Enable Spicetify for Spotify customization";

  config = mkIf config.features.application.spotify.enable {
    programs.spicetify = {
      enable = true;

      # Option 1: Sleek with warm/dark colors (closest to Gruvbox)
      theme = spicePkgs.themes.dribbblish;
      colorScheme = "gruvbox-material-dark"; # Warm reds/browns like Gruvbox

      # Option 2: Try "UltraBlack" for dark Gruvbox feel
      # colorScheme = "UltraBlack";

      # Option 3: Try "Catppuccin" (similar warm tones)
      # colorScheme = "Catppuccin";

      # Useful extensions
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        shuffle
        hidePodcasts
        fullAppDisplay
        keyboardShortcut
      ];

      # Custom apps
      enabledCustomApps = with spicePkgs.apps; [
        newReleases
      ];
    };
  };
}
