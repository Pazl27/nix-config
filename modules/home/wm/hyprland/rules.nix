{
  # Window rules
  windowrule = [

    # Chromium blur fix
    "no_blur ture, match:class ^()$, match:title ^()$"

    # File picker windows
    "float ture, center true, match:title ^(Open File|Open|Save|Save As|Export|Import|Choose File|Rename), match:class ^(.*)$"
    "float true, match:class (thunar), match:title (File Operation Progress)"
    "float true, match:title ((Add|Open).*(File|Folder))"
    "float true, match:title ((Select).*(open))"
    "float true,match:class ^(thunar)$"
    "size 1000 800, match:class ^(thunar)$"
    "center true, match:class ^(thunar)$"
    "opacity 0.8 0.8, match:class (thunar)"

    # Disable borders for swaync
    # "noborder true, match:class (swaync)"

    # JetBrains IDEs
    "float true, match:class ^(jetbrains-clion)$, match:title ^(Welcome to CLion)$"
    "float true, match:class ^(jetbrains-idea)$, match:title ^(Welcome to IntelliJ IDEA)$"
    "float true, match:class ^(jetbrains-rustrover)$, match:title ^(Welcome to RustRover)$"

    # KeePass2
    "float true, match:class ^(KeePass2)$"
    "center true, match:class ^(KeePass2)$"
    "size 1000 600, match:class ^(KeePass2)$, match:title ^(KeePass)$"
    "size 1000 600, match:class ^(KeePass2)$, match:title ^(Database.kdbx - KeePass)$"
    "size 550 300, match:class ^(KeePass2)$, match:title ^(Open Database - Database.kdbx)$"

    # nsxiv
    "size 1000 800, match:class ^(Nsxiv)$, match:title ^(nsxiv)$"
    "center true, match:class ^(Nsxiv)$"

    # Docker Desktop
    "workspace 9, match:class ^(.*Docker Desktop.*)$"

    # Android Emulator
    "float true, match:class ^(Emulator)$"

    # AI assistant
    "float true, match:class ^(askai)$"
    "size 90% 80%, match:class ^(askai)$"
    "center true, match:class ^(askai)$"

    # Drop terminal
    "float true, match:class ^(dropterm)$"
    "workspace special:drop, match:class ^(dropterm)$"
    "size 90% 80%, match:class ^(dropterm)$"
    "center true, match:class ^(dropterm)$"

    # Installer window
    "float true, match:class ^(installer)$"
    "size 90% 80%, match:class ^(installer)$"
    "center true, match:class ^(installer)$"

    # Floating waybar popup
    "float true, match:class ^(floating_waybar)$"
    "size 90% 80%, match:class ^(floating_waybar)$"
    "center true, match:class ^(floating_waybar)$"

    # Inactive opacity for IDEs
    "opacity 1.2, match:class ^(jetbrains-studio)$"
    "opacity 1.2, match:class ^(jetbrains-idea)$"
    "opacity 1.2, match:class ^(jetbrains-rustrover)$"

    # steam
    # Float Steam dialogs, friends list, and settings windows
    "float true, match:class ^(steam)$, match:title ^(Friends List)$"
    "float true, match:class ^(steam)$, match:title ^(Steam Settings)$"
    "float true, match:class ^(steam)$, match:title ^(Settings)$"
    "float true, match:class ^(steam)$, match:title ^(.* - Chat)$"
    "float true, match:class ^(steam)$, match:title ^(Screenshot Manager)$"
    "float true, match:class ^(steam)$, match:title ^(.* - event)$"
    "float true, match:class ^(steam)$, match:title ^(.* - News)$"
    "float true, match:class ^(steam)$, match:title ^(.* - Community)$"
    "float true, match:class ^(steam)$, match:title ^(.* - Properties)$"
    # stream
    "float true, match:title ^(Select what to share)$"
  ];

  # Layer rules
  layerrule = [
    # Waybar
    "blur true, match:namespace (waybar)"
    "ignore_alpha 0.5, match:namespace (waybar)"

    # SwayNC
    # "blur true, match:namespace (swaync-control-center)"
    # "ignore_alpha 0.5, match:namespace swaync-control-center"
    # "blur true, match:namespace (swaync-notification-window)"
    # "ignore_alpha 0.5, match:namespace swaync-notification-window"
    "animation slide right, match:namespace (swaync-notification-window)"

    # Wlogout
    "blur true, match:namespace logout_dialog"
    # "animation popin, match:namespace logout_dialog"

    # Rofi
    "dim_around true, match:namespace (rofi)"
    "animation slide top, match:namespace rofi"
  ];
}
