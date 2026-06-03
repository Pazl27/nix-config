{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.features.application.noctalia.enable = mkEnableOption "Noctalia shell with Gruvbox theme";

  config = mkIf config.features.application.noctalia.enable {
    programs.noctalia-shell = {
      enable = true;
      settings = {
        bar = {
          density = "normal";
          position = "left";
          showCapsule = false;
          widgets = {
            # waybar left: power, clock, media
            left = [
              {
                id = "SessionMenu";
              }
              {
                id = "Clock";
                formatHorizontal = "HH:mm";
                formatVertical = "HH\nmm";
                useMonospacedFont = true;
                usePrimaryColor = true;
              }
              {
                id = "MediaMini";
              }
            ];
            # waybar center: workspaces
            center = [
              {
                id = "Workspace";
                hideUnoccupied = false;
                labelMode = "none";
              }
            ];
            # waybar right: system stats, tray, volume, mic, network, bluetooth, notifications
            right = [
              {
                id = "SystemMonitor";
                compactMode = true;
              }
              {
                id = "Tray";
              }
              {
                id = "Volume";
              }
              {
                id = "Microphone";
              }
              {
                id = "Network";
              }
              {
                id = "Bluetooth";
              }
              {
                id = "NotificationHistory";
              }
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
            ];
          };
        };
        wallpaper = {
          directory = "/home/desktop/Pictures/wallpaper";
          overviewEnabled = true;
        };
        colorSchemes.predefinedScheme = "Gruvbox";
        general = {
          radiusRatio = 0.2;
        };
      };
    };

    home.file.".cache/noctalia/wallpapers.json" = {
      text = builtins.toJSON {
        defaultWallpaper = "/home/desktop/Pictures/wallpaper/anime/watercolor.png";
        wallpapers = {
          "DP-1" = "/home/desktop/Pictures/wallpaper/anime/watercolor.png";
        };
      };
    };
  };
}
