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
    programs.noctalia = {
      enable = true;
      settings = {
        shell = {
          corner_radius_scale = 0.5;
          shared_gl_context = false;

          screenshot = {
            directory = "/home/desktop/Pictures/Screenshots";
          };
        };

        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Gruvbox";
        };

        # Wallpaper handled externally by awww-daemon (see niri startup),
        # so disable Noctalia's own wallpaper surface.
        wallpaper = {
          enabled = false;
          directory = "/home/desktop/Pictures/wallpaper";
          default = {
            path = "/home/desktop/Pictures/wallpaper/anime/watercolor.png";
          };
        };

        # Disable all desktop-layer widgets.
        desktop_widgets = {
          enabled = false;
        };

        # Resolve approximate coordinates from IP (feeds weather widget).
        location = {
          auto_locate = true;
        };

        bar.main = {
          position = "left";
          thickness = 40;
          margin_ends = 0;
          margin_edge = 0;
          radius = 0;
          background_opacity = 1.0;
          reserve_space = true;
          capsule = false;

          start = [
            "session"
            "date"
            "clock"
            "weather"
            "media"
            "audio-vis"
          ];
          center = [
            "workspaces"
          ];
          end = [
            "cpu"
            "gpu"
            "ram"
            "disk"
            "spacer"
            "tray"
            "spacer"
            "volume"
            "input-volume"
            "network"
            "bluetooth"
            "spacer"
            "notifications"
            "control-center"
          ];
        };

        widget = {
          workspaces = {
            display = "none";
            hide_when_empty = false;
          };
          clock = {
            vertical_format = "{:%H}\n{:%M}";
            tooltip_format = "{:%A, %B %d, %Y}";
          };

          # Date shown above the clock (named clock instance).
          date = {
            type = "clock";
            vertical_format = "{:%d}\n{:%m}";
            tooltip_format = "{:%A, %B %d, %Y}";
          };

          # Weather shown below the clock (uses IP-based location).
          weather = {
            type = "weather";
          };

          # Audio visualizer shown below the media widget.
          "audio-vis" = {
            type = "audio_visualizer";
            width = 40;
            bands = 20;
            centered = true;
            show_when_idle = false;
            color_1 = "primary";
            color_2 = "secondary";
          };

          # Input (microphone) volume shown below the output volume.
          "input-volume" = {
            type = "volume";
            device = "input";
          };

          cpu = {
            display = "gauge";
            show_label = false;
          };
          gpu = {
            type = "sysmon";
            stat = "gpu_usage";
            display = "gauge";
            show_label = false;
          };
          ram = {
            stat = "ram_pct";
            display = "gauge";
            show_label = false;
          };
          disk = {
            type = "sysmon";
            stat = "disk_pct";
            path = "/";
            display = "gauge";
            show_label = false;
          };

          tray = {
            drawer = true;
          };

          spacer = {
            length = 10;
          };

          bluetooth.scale = 1.2;
          notifications.scale = 1.2;
          "control-center".scale = 1.2;
        };
      };
    };
  };
}
