{ appLauncher, gpu, ... }:
let
  rofiCommand =
    if appLauncher == "launchpad" then
      "rofi -show drun -theme ~/.config/rofi/launchpad.rasi"
    else
      "rofi -show drun";
in
{
  # Hardware cursors are broken on the proprietary NVIDIA driver
  env = (if gpu == "nvidia" then [ "WLR_NO_HARDWARE_CURSORS,1" ] else [ ]) ++ [
    "XCURSOR_SIZE,24"

    "XDG_CURRENT_DESKTOP,Hyprland"
    "XDG_SESSION_TYPE,wayland"
    "XDG_SESSION_DESKTOP,Hyprland"
    "GTK_USE_PORTAL,1"
  ];

  # Programs
  "$terminal" = "kitty";
  "$fileManager" = "thunar";
  "$menu" = rofiCommand;
  "$browser" = "firefox";
  "$scriptDir" = "$HOME/.config/scripts";
  "$mainMod" = "SUPER";
}
