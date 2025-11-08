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
    xdg.configFile."hypr/hyprlock.conf".text = ''
      # Gruvbox color variables
      $background = rgb(1d2021)
      $foreground = rgb(ebdbb2)
      $red = rgb(fb4934)
      $green = rgb(b8bb26)
      $yellow = rgb(fabd2f)
      $blue = rgb(83a598)
      $purple = rgb(d3869b)
      $aqua = rgb(8ec07c)
      $orange = rgb(fe8019)

      # BACKGROUND
      background {
          monitor =
          path = screenshot
          color = $background
          blur_passes = 2
          contrast = 1
          brightness = 0.5
          vibrancy = 0.2
          vibrancy_darkness = 0.2
      }

      # GENERAL
      general {
          no_fade_in = true
          no_fade_out = true
          hide_cursor = false
          grace = 0
          disable_loading_bar = true
      }

      # INPUT FIELD
      input-field {
          monitor =
          size = 250, 60
          outline_thickness = 2
          dots_size = 0.2
          dots_spacing = 0.35
          dots_center = true
          outer_color = rgba(0, 0, 0, 0)
          inner_color = rgba(40, 40, 40, 0.5)
          font_color = $foreground
          fade_on_empty = false
          rounding = 8
          check_color = $orange
          fail_color = $red
          placeholder_text = <i><span foreground="##ebdbb2">Input Password...</span></i>
          hide_input = false
          position = 0, -200
          halign = center
          valign = center
      }

      # DATE
      label {
          monitor =
          text = cmd[update:1000] echo "$(date +"%A, %B %d")"
          color = $foreground
          font_size = 22
          font_family = JetBrains Mono
          position = 0, 300
          halign = center
          valign = center
      }

      # TIME
      label {
          monitor = 
          text = cmd[update:1000] echo "$(date +"%-I:%M")"
          color = $foreground
          font_size = 95
          font_family = JetBrains Mono Extrabold
          position = 0, 200
          halign = center
          valign = center
      }

      # Profile Picture
      image {
          monitor =
          path = ~/Pictures/wallpaper/gruvbox/minimalistic/orbit.png 
          size = 100
          border_size = 2
          border_color = $orange
          position = 0, -100
          halign = center
          valign = center
      }

      # Battery Status
      label {
          monitor =
          text = cmd[update:1000] echo "$($HOME/.config/scripts/battery.sh)"
          color = $foreground
          font_size = 15
          font_family = JetBrains Mono
          position = -15, -10
          halign = right
          valign = top
      }

      # Username
      # label {
      #     monitor =
      #     text = cmd[update:1000] echo "$(whoami)"
      #     color = $foreground
      #     font_size = 18
      #     font_family = JetBrains Mono
      #     position = 0, -150
      #     halign = center
      #     valign = center
      # }
    '';

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

      # Turn off screen after 5.5 minutes
      listener {
          timeout = 330
          on-timeout = hyprctl dispatch dpms off
          on-resume = hyprctl dispatch dpms on
      }

      # Suspend after 30 minutes
      listener {
          timeout = 1800
          on-timeout = systemctl suspend
      }
    '';
  };
}
