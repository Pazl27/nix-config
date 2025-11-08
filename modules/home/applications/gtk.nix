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

      # Versuche verschiedene Gruvbox-Namen
      theme = {
        name = "Gruvbox-Dark"; # Geändert von "Gruvbox-Dark-BL"
        package = pkgs.gruvbox-gtk-theme;
      };

      iconTheme = {
        name = "Gruvbox-Plus-Dark";
        package = pkgs.gruvbox-plus-icons;
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
      gruvbox-plus-icons
      bibata-cursors
      lxappearance
    ];

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Gruvbox-Dark"; # Auch hier geändert
        icon-theme = "Gruvbox-Plus-Dark";
        cursor-theme = "Bibata-Modern-Classic";
      };
    };

    home.sessionVariables = {
      GTK_THEME = "Gruvbox-Dark"; # Und hier
      XCURSOR_THEME = "Bibata-Modern-Classic";
      XCURSOR_SIZE = "24";
    };
  };
}

