{
  host ? "desktop",
  ...
}:
{
  exec-once = [
    # "swaync"
    "awww-daemon"
    "waybar"
    "hypridle"
    "battery-notify"
    "hyprctl dispatch workspace 1"
    "wl-paste --type text --watch cliphist store"
    "wl-paste --type image --watch cliphist store"
  ];
}
