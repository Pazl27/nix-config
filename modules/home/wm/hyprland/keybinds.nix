{
  host ? "desktop",
  ...
}:
let
  inherit (import ../../../../hosts/${host}/variables.nix) hyprland_layout;

  # Common keybindings (always included)
  commonBinds = [
    # Applications
    "$mainMod, Return, exec, $terminal"
    "$mainMod, Q, killactive"
    "$mainMod SHIFT, E, exec, $fileManager"
    "$mainMod, E, exec, $scriptDir/yazi.sh"
    "$mainMod, B, exec, $browser"
    "$mainMod, V, togglefloating"
    "$mainMod, SPACE, exec, $menu"
    "$mainMod, N, exec, swaync-client -t"
    "$mainMod, W, exec, $scriptDir/rofi/wifi.sh"
    "$mainMod, G, exec, $scriptDir/rofi/wallpaper_switcher.sh"
    "$mainMod, A, exec, $scriptDir/rofi/ai/askai.sh"
    "$mainMod, R, exec, $scriptDir/rofi/repo-rofi.sh"
    "$mainMod SHIFT, S, exec, $scriptDir/snapshot.sh"
    "$mainMod, I, exec, $scriptDir/wlogout.sh"
    "$mainMod, P, exec, $scriptDir/rofi/list-installer.sh"
    "$mainMod, Y, exec, $scriptDir/rofi/clipboard.sh"

    # Window management
    "$mainMod, Tab, cyclenext"
    "$mainMod, Tab, bringactivetotop"

    # Focus movement
    "$mainMod, h, movefocus, l"
    "$mainMod, l, movefocus, r"

    # Monitor movement
    "$mainMod SHIFT CTRL, H, movewindow, mon:l"
    "$mainMod SHIFT CTRL, L, movewindow, mon:r"
  ];

  # Hyprscrolling specific keybinds
  scrollingBinds = [
    "$mainMod, comma, layoutmsg, movewindowto l"
    "$mainMod, period, layoutmsg, movewindowto r"
    "$mainMod SHIFT, L, layoutmsg, swapcol r"
    "$mainMod SHIFT, H, layoutmsg, swapcol l"
    "$mainMod SHIFT, j, movetoworkspace, +1"
    "$mainMod SHIFT, k, movetoworkspace, -1"
    "$mainMod, up, movefocus, u"
    "$mainMod, down, movefocus, d"
    "$mainMod, j, workspace, +1"
    "$mainMod, k, workspace, -1"
    "$mainMod, f, layoutmsg, colresize -conf"
    "$mainMod SHIFT, f, fullscreen"
    "$mainMod, D, layoutmsg, orientationcycle left top"
  ];

  # Default (dwindle) keybinds
  defaultBinds = [
    "$mainMod SHIFT, h, movewindow, l"
    "$mainMod SHIFT, l, movewindow, r"
    "$mainMod SHIFT, j, movewindow, d"
    "$mainMod SHIFT, k, movewindow, u"
    "$mainMod, j, movefocus, d"
    "$mainMod, k, movefocus, u"
    "$mainMod, f, fullscreen"
  ];

  # Choose layout-specific binds based on hyprland_layout variable
  layoutBinds = if hyprland_layout == "scrolling" then scrollingBinds else defaultBinds;
in
{
  # Keybindings
  bind =
    commonBinds
    ++ layoutBinds
    ++ [

      # Resize windows
      "$mainMod ALT, l, resizeactive, 10 0"
      "$mainMod ALT, h, resizeactive, -10 0"
      "$mainMod ALT, k, resizeactive, 0 -10"
      "$mainMod ALT, j, resizeactive, 0 10"

      # Workspaces
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      # Move to workspace
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"

      # Scroll workspaces
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"

      # Lock
      "ALT CTRL, Q, exec, hyprlock"

      # Brightness
      ", XF86MonBrightnessDown, exec, $scriptDir/brightness.sh --dec"
      ", XF86MonBrightnessUp, exec, $scriptDir/brightness.sh --inc"
    ];

  # Mouse bindings
  bindm = [
    "$mainMod, mouse:272, movewindow"
    # "$mainMod, Control_L, movewindow"
    "$mainMod, mouse:273, resizewindow"
    # "$mainMod, ALT_L, resizewindow"
  ];

  # Media keys
  bindel = [
    ", XF86AudioRaiseVolume, exec, $scriptDir/volume.sh --inc"
    ", XF86AudioLowerVolume, exec, $scriptDir/volume.sh --dec"
  ];

  bindl = [
    ", XF86AudioMute, exec, $scriptDir/volume.sh --toggle"
    ", XF86AudioPlay, exec, playerctl play-pause"
    ", XF86AudioPrev, exec, playerctl previous"
    ", XF86AudioNext, exec, playerctl next"
    ", switch:Lid Switch, exec, hyprlock"
  ];
}
