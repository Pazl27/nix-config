{ host ? "desktop", ... }:
let
  inherit (import ../../../../hosts/${host}/variables.nix) hyprland_layout;
  layout = if hyprland_layout == "scrolling" then "scrolling" else "dwindle";
in
{
  # General settings
  general = {
    layout = layout;
    border_size = 3;
    "col.active_border" = "rgb(DF4633) rgb(1e2122) rgb(1e2122) rgb(DF4633)";
    "col.inactive_border" = "rgb(24273A) rgb(24273A) rgb(24273A) rgb(27273A) 45deg";
    gaps_in = 2;
    gaps_out = 5;
  };

  debug = {
    disable_logs = false;
  };

  # Decoration
  decoration = {
    rounding = 10;
    active_opacity = 1.0;
    inactive_opacity = 0.9;

    shadow = {
      enabled = true;
      range = 4;
      render_power = 3;
      color = "rgba(1a1a1aee)";
    };

    blur = {
      enabled = true;
      size = 6;
      passes = 4;
      ignore_opacity = true;
      xray = true;
      new_optimizations = true;
    };
  };

  # Animations
  animations = {
    enabled = true;

    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

    animation = [
      "windows, 1, 7, myBezier"
      "windowsOut, 1, 7, default, popin 80%"
      "border, 1, 10, default"
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      "workspaces, 1, 6, default"
      "workspaces, 1, 5, default, slidevert"
    ];
  };

  # Dwindle layout
  dwindle = {
    pseudotile = true;
    preserve_split = true;
  };

  # Master layout
  master = {
    new_status = "master";
  };

  # Misc settings
  misc = {
    force_default_wallpaper = 0;
    disable_hyprland_logo = true;
  };

  # Input settings
  input = {
    kb_layout = "de";
    follow_mouse = 1;
    sensitivity = 0;

    touchpad = {
      natural_scroll = true;
      scroll_factor = 0.4;
    };
  };

  # Device-specific settings
  device = [
    {
      name = "razer-razer-viper-ultimate-dongle-1";
      sensitivity = -0.6;
    }
    {
      name = "finalmouse-ultralightx-dongle-mouse";
      sensitivity = -0.8;
    }
  ];

  # Plugin settings
  plugin = {
    hyprscrolling = {
      fullscreen_on_one_column = true;
      explicit_column_widths = "0.5, 1";
    };
  };
}
