{
  env = [
    "WLR_NO_HARDWARE_CURSORS,1"
    "XCURSOR_SIZE,24"

    "XDG_CURRENT_DESKTOP,Hyprland"
    "XDG_SESSION_TYPE,wayland"
    "XDG_SESSION_DESKTOP,Hyprland"
    "GTK_USE_PORTAL,1"
  ];

  # Programs
  "$terminal" = "kitty";
  "$fileManager" = "thunar";
  "$menu" = "rofi -show drun";
  "$browser" = "firefox";
  "$scriptDir" = "$HOME/.config/scripts";
  "$mainMod" = "SUPER";
}
