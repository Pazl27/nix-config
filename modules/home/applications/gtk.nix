{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.features.application.gtk = {
    enable = mkEnableOption "GTK theme configuration";
  };

  config = mkIf config.features.application.gtk.enable {
    gtk = {
      enable = true;

      # theme = {
      #   name = "Gruvbox-Dark";
      #   package = pkgs.gruvbox-gtk-theme;
      # };

      theme = {
        name = "Colloid-Red-Dark-Gruvbox";
        package = pkgs.colloid-gtk-theme;
      };

      iconTheme = {
        name = "Colloid-Red-Gruvbox-Dark";
        package = pkgs.colloid-icon-theme;
      };

      cursorTheme = {
        name = "Gruvbox";
        package = pkgs.capitaine-cursors-themed;
        size = 24;
      };

      font = {
        name = "Ubuntu";
        size = 11;
        package = pkgs.ubuntu-classic;
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };

      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };

    home.packages = with pkgs; [
      gruvbox-gtk-theme
      colloid-gtk-theme
      colloid-icon-theme
      bibata-cursors
      capitaine-cursors-themed

      nwg-look
    ];

    home.sessionVariables = {
      # GTK_THEME = "Gruvbox-Dark";
      XCURSOR_THEME = "Bibata-Modern-Classic";
      XCURSOR_SIZE = "24";
    };

    home.pointerCursor = {
      name = "Gruvbox";
      package = pkgs.capitaine-cursors-themed;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };
  };
}

