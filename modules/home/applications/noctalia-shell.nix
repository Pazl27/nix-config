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
          source = "custom";
          custom_palette = "GruvboxRed";
        };

        wallpaper = {
          enabled = true;
          directory = "/home/desktop/Pictures/wallpaper";
          default = {
            path = "/home/desktop/Pictures/wallpaper/anime/watercolor.png";
          };
        };

        # Blurred/tinted copy of the wallpaper rendered into niri's overview backdrop.
        backdrop = {
          enabled = true;
          blur_intensity = 0.5;
          tint_intensity = 0.3;
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

      # Gruvbox palette with a red primary accent to match the niri
      # border and the unified rofi outline. Written to
      # ~/.config/noctalia/palettes/GruvboxRed.json and selected above.
      customPalettes.GruvboxRed = {
        dark = {
          mPrimary = "#fb4934";
          mOnPrimary = "#282828";
          mSecondary = "#fe8019";
          mOnSecondary = "#282828";
          mTertiary = "#d3869b";
          mOnTertiary = "#282828";
          mError = "#fb4934";
          mOnError = "#282828";
          mSurface = "#282828";
          mOnSurface = "#ebdbb2";
          mSurfaceVariant = "#3c3836";
          mOnSurfaceVariant = "#ebdbb2";
          mOutline = "#504945";
          mShadow = "#1d2021";
          mHover = "#3c3836";
          mOnHover = "#ebdbb2";
          terminal = {
            background = "#282828";
            foreground = "#ebdbb2";
            cursor = "#ebdbb2";
            cursorText = "#282828";
            selectionBg = "#ebdbb2";
            selectionFg = "#282828";
            normal = {
              black = "#282828";
              red = "#cc241d";
              green = "#98971a";
              yellow = "#d79921";
              blue = "#458588";
              magenta = "#b16286";
              cyan = "#689d6a";
              white = "#a89984";
            };
            bright = {
              black = "#928374";
              red = "#fb4934";
              green = "#b8bb26";
              yellow = "#fabd2f";
              blue = "#83a598";
              magenta = "#d3869b";
              cyan = "#8ec07c";
              white = "#ebdbb2";
            };
          };
        };
        light = {
          mPrimary = "#cc241d";
          mOnPrimary = "#fbf1c7";
          mSecondary = "#d65d0e";
          mOnSecondary = "#fbf1c7";
          mTertiary = "#b16286";
          mOnTertiary = "#fbf1c7";
          mError = "#cc241d";
          mOnError = "#fbf1c7";
          mSurface = "#fbf1c7";
          mOnSurface = "#3c3836";
          mSurfaceVariant = "#ebdbb2";
          mOnSurfaceVariant = "#3c3836";
          mOutline = "#a89984";
          mShadow = "#d5c4a1";
          mHover = "#ebdbb2";
          mOnHover = "#3c3836";
          terminal = {
            background = "#fbf1c7";
            foreground = "#3c3836";
            cursor = "#3c3836";
            cursorText = "#fbf1c7";
            selectionBg = "#3c3836";
            selectionFg = "#fbf1c7";
            normal = {
              black = "#fbf1c7";
              red = "#cc241d";
              green = "#98971a";
              yellow = "#d79921";
              blue = "#458588";
              magenta = "#b16286";
              cyan = "#689d6a";
              white = "#7c6f64";
            };
            bright = {
              black = "#928374";
              red = "#9d0006";
              green = "#79740e";
              yellow = "#b57614";
              blue = "#076678";
              magenta = "#8f3f71";
              cyan = "#427b58";
              white = "#3c3836";
            };
          };
        };
      };
    };
  };
}
