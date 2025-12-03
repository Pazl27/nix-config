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
    home.packages = with pkgs; [
      hyprlock
    ];

    # Copy wlogout icons to config directory
    home.file.".config/wlogout/icons" = {
      source = ../../../assets/wlogout;
      recursive = true;
    };

    programs.wlogout = {
      enable = true;

      layout = [
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "logout";
          action = "loginctl kill-session $XDG_SESSION_ID";
          text = "Logout";
          keybind = "e";
        }
        {
          label = "lock";
          action = "hyprlock";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
        {
          label = "hibernate";
          action = "hyprlock && systemctl hibernate";
          text = "Hibernate";
          keybind = "h";
        }
      ];

      style = ''
        * {
          background-image: none;
          box-shadow: none;
        }

        window {
          font-family: "JetBrains Mono Nerd Font", monospace;
          font-size: 12pt;
          color: #ebdbb2; /* Gruvbox fg */
          background-color: transparent;
        }

        button {
          background-repeat: no-repeat;
          background-position: center;
          background-size: 30%;
          background-color: transparent;
          transition: all 0.3s ease-in;
          box-shadow: 0 0 10px 2px transparent;
          border-radius: 16px;
          margin: 8px;
          border: none;
          min-width: 120px;
          min-height: 120px;
        }

        button:focus,
        button:hover {
          background-size: 45%;
          box-shadow: 0 0 10px 3px rgba(131, 165, 152, 0.5);
          background-color: rgba(131, 165, 152, 0.3); /* Gruvbox aqua with transparency */
          color: transparent;
          transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682), box-shadow 0.5s ease-in;
        }

        #shutdown {
          background-image: image(url("icons/power.png"));
        }

        #shutdown:hover,
        #shutdown:focus {
          background-image: image(url("icons/power-hover.png"));
        }

        #logout {
          background-image: image(url("icons/logout.png"));
        }

        #logout:hover,
        #logout:focus {
          background-image: image(url("icons/logout-hover.png"));
        }

        #reboot {
          background-image: image(url("icons/restart.png"));
        }

        #reboot:hover,
        #reboot:focus {
          background-image: image(url("icons/restart-hover.png"));
        }

        #lock {
          background-image: image(url("icons/lock.png"));
        }

        #lock:hover,
        #lock:focus {
          background-image: image(url("icons/lock-hover.png"));
        }

        #hibernate {
          background-image: image(url("icons/hibernate.png"));
        }

        #hibernate:hover,
        #hibernate:focus {
          background-image: image(url("icons/hibernate-hover.png"));
        }
      '';
    };
  };
}
