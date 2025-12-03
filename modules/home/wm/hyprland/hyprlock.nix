{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.features.wm.hyprland.hyprlock.enable =
    mkEnableOption "Enable Hyprlock screen locker with Gruvbox theme";

  config = mkIf config.features.wm.hyprland.hyprlock.enable {
    # Install hyprlock and hypridle
    home.packages = with pkgs; [
      hyprlock
      hypridle
    ];

    # Hyprlock configuration
    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          disable_loading_bar = true;
          hide_cursor = true;
          grace = 0;
          no_fade_in = false;
        };

        background = [
          {
            monitor = "";
            path = "screenshot";
            blur_size = 7;
            blur_passes = 4;
            noise = 0.0117;
            contrast = 1.1;
            brightness = 0.8;
            vibrancy = 0.21;
            vibrancy_darkness = 0.0;
          }
        ];

        # Hours
        label = [
          {
            monitor = "";
            text = ''cmd[update:1000] echo "<b><big> $(date +"%H") </big></b>"'';
            color = "rgb(131, 165, 152)"; # Gruvbox aqua
            font_size = 112;
            font_family = "JetBrains Mono Nerd Font";
            shadow_passes = 3;
            shadow_size = 4;
            position = "0, 220";
            halign = "center";
            valign = "center";
          }
          # Minutes
          {
            monitor = "";
            text = ''cmd[update:1000] echo "<b><big> $(date +"%M") </big></b>"'';
            color = "rgb(131, 165, 152)"; # Gruvbox aqua
            font_size = 112;
            font_family = "JetBrains Mono Nerd Font";
            shadow_passes = 3;
            shadow_size = 4;
            position = "0, 80";
            halign = "center";
            valign = "center";
          }
          # Day of week
          {
            monitor = "";
            text = ''cmd[update:18000000] echo "<b><big> $(date +'%A') </big></b>"'';
            color = "rgb(235, 219, 178)"; # Gruvbox fg
            font_size = 22;
            font_family = "JetBrains Mono Nerd Font";
            position = "0, -20";
            halign = "center";
            valign = "center";
          }
          # Date
          {
            monitor = "";
            text = ''cmd[update:18000000] echo "<b> $(date +'%d %b') </b>"'';
            color = "rgb(235, 219, 178)"; # Gruvbox fg
            font_size = 18;
            font_family = "JetBrains Mono Nerd Font";
            position = "0, -50";
            halign = "center";
            valign = "center";
          }
          # Weather
          {
            monitor = "";
            text = ''cmd[update:1800000] echo "<b>Feels like<big> $(${pkgs.curl}/bin/curl -s 'wttr.in?format=%t' 2>/dev/null | ${pkgs.gnused}/bin/sed 's/+//g' || echo 'N/A') </big></b>"'';
            color = "rgb(235, 219, 178)"; # Gruvbox fg
            font_size = 18;
            font_family = "JetBrains Mono Nerd Font";
            position = "0, 40";
            halign = "center";
            valign = "bottom";
          }
        ];

        input-field = [
          {
            monitor = "";
            size = "250, 50";
            outline_thickness = 3;
            dots_size = 0.26;
            dots_spacing = 0.64;
            dots_center = true;
            dots_rounding = -1;
            rounding = 22;
            outer_color = "rgb(40, 40, 40)"; # Gruvbox bg
            inner_color = "rgb(40, 40, 40)"; # Gruvbox bg
            font_color = "rgb(131, 165, 152)"; # Gruvbox aqua
            fade_on_empty = true;
            placeholder_text = "<i>Password...</i>";
            hide_input = false;
            position = "0, -120";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };

    # Hypridle configuration for automatic locking
    xdg.configFile."hypr/hypridle.conf".text = ''
      general {
          lock_cmd = pidof hyprlock || hyprlock
          before_sleep_cmd = loginctl lock-session
          after_sleep_cmd = hyprctl dispatch dpms on
      }

      # Lock after 5 minutes
      listener {
          timeout = 300
          on-timeout = loginctl lock-session
      }

      # Turn off screen after 6 minutes
      listener {
          timeout = 360
          on-timeout = hyprctl dispatch dpms off
          on-resume = hyprctl dispatch dpms on
      }

      # Suspend after 30 minutes
      # listener {
      #     timeout = 1800
      #     on-timeout = systemctl suspend
      # }
    '';
  };
}
