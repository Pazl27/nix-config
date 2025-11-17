{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland.settings = {
    # Monitor configuration

    # Environment variables
    env = [
      "WLR_NO_HARDWARE_CURSORS,1"
      "XCURSOR_SIZE,24"
      "HYPRCURSOR_SIZE,24"
    ];

    # Programs
    "$terminal" = "kitty";
    "$fileManager" = "thunar";
    "$menu" = "rofi -show drun";
    "$browser" = "firefox";
    "$scriptDir" = "$HOME/.config/scripts";
    "$mainMod" = "SUPER";

    # General settings
    general = {
      layout = "scrolling";
      border_size = 3;
      "col.active_border" = "rgb(DF4633) rgb(1e2122) rgb(1e2122) rgb(DF4633)";
      "col.inactive_border" = "rgb(24273A) rgb(24273A) rgb(24273A) rgb(27273A) 45deg";
      gaps_in = 2;
      gaps_out = 5;
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

    # Keybindings
    bind = [
      # Applications
      "$mainMod, Return, exec, $terminal"
      "$mainMod, Q, killactive"
      "$mainMod, M, exit"
      "$mainMod SHIFT, E, exec, $fileManager"
      "$mainMod, E, exec, $scriptDir/yazi.sh"
      "$mainMod, B, exec, $browser"
      "$mainMod, V, togglefloating"
      "$mainMod, SPACE, exec, $menu"
      "$mainMod, D, togglesplit"
      "$mainMod, N, exec, swaync-client -t"
      "$mainMod, W, exec, $scriptDir/rofi/wifi.sh"
      "$mainMod, G, exec, $scriptDir/rofi/wallpaper_switcher.sh"
      "$mainMod, A, exec, $scriptDir/rofi/ai/askai.sh"
      "$mainMod, R, exec, $scriptDir/rofi/repo-rofi.sh"
      "$mainMod SHIFT, S, exec, $scriptDir/snapshot.sh"
      "$mainMod, I, exec, wlogout"
      "$mainMod, P, exec, $scriptDir/rofi/list-installer.sh"

      # Window management
      "$mainMod, Tab, cyclenext"
      "$mainMod, Tab, bringactivetotop"

      # Focus movement
      "$mainMod, h, movefocus, l"
      "$mainMod, l, movefocus, r"

      # Hyprscrolling
      "$mainMod SHIFT, H, layoutmsg, swapcol l"
      "$mainMod SHIFT, L, layoutmsg, swapcol r"
      "$mainMod SHIFT, j, movetoworkspace, +1"
      "$mainMod SHIFT, k, movetoworkspace, -1"
      "$mainMod, j, workspace, +1"
      "$mainMod, k, workspace, -1"
      "$mainMod, f, layoutmsg, colresize -conf"
      "$mainMod SHIFT, f, fullscreen"

      # witout hyprscrolling
      # "$mainMod SHIFT, h, movewindow, l"
      # "$mainMod SHIFT, l, movewindow, r"
      # "$mainMod SHIFT, j, movewindow, d"
      # "$mainMod SHIFT, k, movewindow, u"
      # "$mainMod, j, movefocus, d"
      # "$mainMod, k, movefocus, u"
      # "$mainMod, f, fullscreen"

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
      "$mainMod, Control_L, movewindow"
      "$mainMod, mouse:273, resizewindow"
      "$mainMod, ALT_L, resizewindow"
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

    # Window rules
    windowrulev2 = [
      # Chromium blur fix
      "noblur, class:^()$, title:^()$"

      # Suppress maximize events
      "suppressevent maximize, class:.*"

      # Fix XWayland drag issues
      "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

      # File picker windows
      "float, center, title:^(Open File|Open|Save|Save As|Export|Import|Choose File|Rename), class:^(.*)$"

      # Disable borders for swaync
      "noborder, class:(swaync)"

      # JetBrains IDEs
      "float,class:^(jetbrains-clion)$,title:^(Welcome to CLion)$"
      "float,class:^(jetbrains-idea)$,title:^(Welcome to IntelliJ IDEA)$"
      "float,class:^(jetbrains-rustrover)$,title:^(Welcome to RustRover)$"

      # KeePass2
      "float,class:^(KeePass2)$"
      "center, class:^(KeePass2)$"
      "size 1000 600, class:^(KeePass2)$, title:^(KeePass)$"
      "size 1000 600, class:^(KeePass2)$, title:^(Database.kdbx - KeePass)$"
      "size 550 300, class:^(KeePass2)$, title:^(Open Database - Database.kdbx)$"

      # nsxiv
      "size 1000 800, class:^(Nsxiv)$, title:^(nsxiv)$"
      "center, class:^(Nsxiv)$"

      # Docker Desktop
      "workspace 9, class:^(.*Docker Desktop.*)$"

      # Android Emulator
      "float,class:^(Emulator)$"

      # AI assistant
      "float,class:^(askai)$"
      "size 90% 80%,class:^(askai)$"
      "center,class:^(askai)$"

      # Drop terminal
      "float,class:^(dropterm)$"
      "workspace special:drop,class:^(dropterm)$"
      "size 90% 80%,class:^(dropterm)$"
      "center,class:^(dropterm)$"

      # Installer window
      "float,class:^(installer)$"
      "size 90% 80%,class:^(installer)$"
      "center,class:^(installer)$"

      # Floating waybar popup
      "float,class:^(floating_waybar)$"
      "size 90% 80%,class:^(floating_waybar)$"
      "center,class:^(floating_waybar)$"

      # Inactive opacity for IDEs
      "opacity 1.2, class:^(jetbrains-studio)$"
      "opacity 1.2, class:^(jetbrains-idea)$"
      "opacity 1.2, class:^(jetbrains-rustrover)$"

      # steam
      # Float Steam dialogs, friends list, and settings windows
      "float, class:^(steam)$, title:^(Friends List)$"
      "float, class:^(steam)$, title:^(Steam Settings)$"
      "float, class:^(steam)$, title:^(Settings)$"
      "float, class:^(steam)$, title:^(.* - Chat)$"
      "float, class:^(steam)$, title:^(Screenshot Manager)$"
      "float, class:^(steam)$, title:^(.* - event)$"
      "float, class:^(steam)$, title:^(.* - News)$"
      "float, class:^(steam)$, title:^(.* - Community)$"
      "float, class:^(steam)$, title:^(.* - Properties)$"
    ];

    # Layer rules
    layerrule = [
      # Waybar
      "blur, waybar"
      "ignorezero, waybar"
      "ignorealpha 0.5, waybar"

      # SwayNC
      "blur, swaync-control-center"
      "blur, swaync-notification-window"
      "ignorezero, swaync-control-center"
      "ignorezero, swaync-notification-window"
      "ignorealpha 0.5, swaync-control-center"
      "ignorealpha 0.5, swaync-notification-window"

      # Wlogout
      "blur, logout_dialog"

      # Rofi
      "dimaround, rofi"
      "blur, rofi"
      "animation slide top, rofi"
    ];

    # Autostart
    exec-once = [
      "swaync"
      "swww-daemon"
      "waybar"
      "udiskie"
      "hypridle"
      "battery-notify"
      "hyprpm reload -n"
      "hyprctl dispatch workspace 1"
    ];
  };
}
