{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.features.application.wlogout = {
    enable = mkEnableOption "Wlogout power menu configuration";
  };

  config = mkIf config.features.application.wlogout.enable {
    # Wlogout package
    home.packages = with pkgs; [
      wlogout
      hyprlock
      nerd-fonts.jetbrains-mono
    ];

    # Wlogout configuration
    xdg.configFile."wlogout/layout".text = ''
      {
          "label" : "lock",
          "action" : "hyprlock",
          "text" : "Lock",
          "keybind" : "l"
      }
      {
          "label" : "hibernate",
          "action" : "systemctl hibernate",
          "text" : "Hibernate",
          "keybind" : "h"
      }
      {
          "label" : "logout",
          "action" : "hyprctl dispatch exit",
          "text" : "Logout",
          "keybind" : "e"
      }
      {
          "label" : "shutdown",
          "action" : "systemctl poweroff",
          "text" : "Shutdown",
          "keybind" : "s"
      }
      {
          "label" : "suspend",
          "action" : "systemctl suspend",
          "text" : "Suspend",
          "keybind" : "u"
      }
      {
          "label" : "reboot",
          "action" : "systemctl reboot",
          "text" : "Reboot",
          "keybind" : "r"
      }
    '';

    # Wlogout CSS styling
    xdg.configFile."wlogout/style.css".text = ''
      * {
        background-image: none;
      }

      window {
        background-color: rgba(0, 0, 0, 0);
      }

      button {
        color: #cc241d;
        font-family: "JetBrains Mono Nerd Font";
        background-color: #1d2021;
        border-radius: 20px;
        border-style: none;
        border-width: 0px;
        margin: 10px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
      }

      button:focus, button:active, button:hover {
        background-color: #ebdbb2;
        outline-style: solid;
      }

      #lock, #logout, #suspend, #hibernate, #shutdown, #reboot {
        opacity: 0.9;
      }

      #lock {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
      }

      #logout {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
      }

      #suspend {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
      }

      #hibernate {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
      }

      #shutdown {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
      }

      #reboot {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
      }
    '';
  };
}

