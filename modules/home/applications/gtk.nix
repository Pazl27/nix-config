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

      theme = {
        name = "Colloid-Red-Dark-Gruvbox";
        package = pkgs.colloid-gtk-theme.override {
          themeVariants = [ "red" ]; # Farbe: red
          colorVariants = [ "dark" ]; # Helligkeit: dark
          sizeVariants = [ "standard" ]; # Größe: standard
          tweaks = [ "gruvbox" ]; # Gruvbox palette!
        };
      };

      iconTheme = {
        name = "Colloid-Red-Gruvbox-Dark";
        package = pkgs.colloid-icon-theme.override {
          schemeVariants = [ "gruvbox" ];
          colorVariants = [ "red" ];
        };
      };

      cursorTheme = {
        name = "Capitaine Cursors (Gruvbox)";
        package = pkgs.capitaine-cursors-themed;
        size = 24;
      };

      font = {
        name = "Ubuntu";
        size = 11;
        package = pkgs.ubuntu-classic;
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };

      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    home.pointerCursor = {
      name = "Capitaine Cursors (Gruvbox)";
      package = pkgs.capitaine-cursors-themed;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    home.packages = with pkgs; [
      nwg-look
    ];
  };
}
