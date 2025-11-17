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
      wayland = true;

      # Text theme with Gruvbox colors
      theme = spicePkgs.themes.text;
      colorScheme = "Gruvbox";

      # Enable images in text theme
      customColorScheme = {
        text = "fbf1c7";
        subtext = "ebdbb2";
        sidebar-text = "fbf1c7";
        main = "282828";
        sidebar = "1d2021";
        player = "282828";
        card = "3c3836";
        shadow = "000000";
        selected-row = "504945";
        button = "98971a";
        button-active = "b8bb26";
        button-disabled = "665c54";
        tab-active = "98971a";
        notification = "d79921";
        notification-error = "cc241d";
        misc = "504945";
      };

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

    # Create custom CSS file to enable images
    home.file.".config/spicetify/Themes/text/user.css".text = ''
      /* Enable all images in text theme */
      :root {
        --display-card-image: block;
        --display-coverart-image: block;
        --display-header-image: block;
        --display-sidebar-image: block;
        --display-tracklist-image: block;
      }
    '';
  };
}
