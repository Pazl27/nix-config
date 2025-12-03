{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.features.application.waybar = {
    enable = mkEnableOption "Waybar status bar configuration";
  };

  config = mkIf config.features.application.waybar.enable {
    # Waybar package
    home.packages = with pkgs; [
      waybar

      pavucontrol
      playerctl
      blueman
      networkmanagerapplet
      swaynotificationcenter
      wlogout
      hyprpicker
      wl-clipboard
      curl
    ];

    # Waybar configuration
    programs.waybar = {
      enable = true;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          output = [ "*" ];
          reload_style_on_change = true;

          modules-left = [
            "custom/power"
            "custom/weather"
            "clock"
            "mpris"
          ];

          modules-center = [
            "hyprland/workspaces"
          ];

          modules-right = [
            "group/expand"
            "tray"
            "custom/screenshot"
            "custom/colorpicker"
            "bluetooth"
            "network"
            "pulseaudio"
            # "custom/endpoint"
            # "battery"
            "custom/notification"
          ];

          # ─── Workspaces ────────────────────────────────────────
          "hyprland/workspaces" = {
            format = "{icon}";
            format-icons = {
              active = "";
              default = "";
              empty = "";
            };
            persistent-workspaces = {
              "*" = [
                1
                2
                3
                4
                5
                6
                7
              ];
            };
          };

          # ─── System Modules ────────────────────────────────────
          clock = {
            actions = {
              on-click = "shift_up";
              on-click-right = "shift_down";
            };
            calendar = {
              format = {
                today = "<span color='#fAfBfC'><b>{}</b></span>";
              };
            };
            format = "{:%d.%m.%Y | %I:%M %p}";
            interval = 1;
            tooltip-format = "<tt>{calendar}</tt>";
          };

          battery = {
            format = "{capacity}% {icon}";
            format-alt = "{time} {icon}";
            format-charging = "{capacity}% 󰂄";
            format-icons = [
              "󰁻"
              "󰁼"
              "󰁾"
              "󰂀"
              "󰂂"
              "󰁹"
            ];
            format-plugged = "{capacity}% 󰂄 ";
            interval = 30;
            states = {
              good = 95;
              warning = 30;
              critical = 20;
            };
          };

          cpu = {
            format = "󰻠";
            tooltip = true;
          };

          memory = {
            format = "";
            interval = 30;
            tooltip = true;
          };

          disk = {
            format = "";
            interval = 30;
          };

          temperature = {
            critical-threshold = 80;
            format = "";
          };

          backlight = {
            format = "{percent}% {icon}";
            format-icons = [
              "󰃞"
              "󰃟"
              "󰃠"
            ];
            tooltip = false;
          };

          tray = {
            icon-size = 16;
            spacing = 10;
          };

          # ─── Audio and Media ───────────────────────────────────
          mpris = {
            format = "{player_icon} {dynamic}";
            format-paused = "{status_icon} <i>{dynamic}</i>";
            player-icons = {
              default = "🎵";
              spotify = "";
            };
            status-icons = {
              paused = "";
              playing = "";
            };
            dynamic-order = [
              "title"
              "artist"
            ];
            dynamic-len = 40;
            dynamic-separator = " - ";
            player-hidden = [
              "firefox"
              "playerctld"
            ];
            on-click = "playerctl -p spotify play-pause";
            on-scroll-up = "playerctl -p spotify previous";
            on-scroll-down = "playerctl -p spotify next";
            ignored-players = [
              "firefox"
              "playerctld"
            ];
          };

          pulseaudio = {
            format = "{volume}% {icon}{format_source}";
            format-bluetooth = "{volume}% {icon}  {format_source}";
            format-bluetooth-muted = "<span foreground='#ea6961'>󰗾 {format_source}</span>";
            format-muted = "<span foreground='#ea6961'></span> {format_source}";
            format-source = "";
            format-source-muted = "<span foreground='#ea6961'></span>";
            format-icons = {
              default = [
                " "
                " "
                " "
              ];
              headphone = "";
              headset = "";
            };
            ignored-sinks = [
              "Easy Effects Sink"
              "Monitor of Easy Effects Sink"
            ];
            on-click = "pavucontrol";
            on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
            scroll-step = 0;
            tooltip = true;
          };

          "custom/weather" = {
            exec = ''
              location=$(curl -s "https://ipinfo.io/city" 2>/dev/null || echo "Unknown")
              temp=$(curl -s "https://wttr.in/?format=%t" 2>/dev/null | sed 's/+//g')
              condition=$(curl -s "https://wttr.in/?format=%C" 2>/dev/null)
              echo "{\"text\":\"$temp\", \"tooltip\":\"$location: $condition\", \"class\":\"weather\"}"
            '';
            interval = 1800;
            format = "{}";
            return-type = "json";
            on-click = "xdg-open https://wttr.in/";
          };

          # ─── Network & Bluetooth ───────────────────────────────
          network = {
            format-disconnected = "󰖪";
            format-ethernet = "󰈀";
            format-linked = "󰈀 {ifname} (No IP)";
            format-wifi = "";
            interval = 2;
            on-click = "nm-connection-editor";
            rotate = 0;
            tooltip = true;
            tooltip-format = "Network: <big><b>{essid}</b></big>\nSignal strength: <b>{signaldBm}dBm ({signalStrength}%)</b>\nFrequency: <b>{frequency}MHz</b>\nInterface: <b>{ifname}</b>\nIP: <b>{ipaddr}/{cidr}</b>\nGateway: <b>{gwaddr}</b>\nNetmask: <b>{netmask}</b>";
            tooltip-format-disconnected = "Disconnected";
          };

          bluetooth = {
            format-connected-battery = "{device_battery_percentage}% 󰂯";
            format-disabled = "󰂲";
            format-off = "BT-off";
            format-on = "󰂯";
            on-click = "blueman-manager";
            on-click-right = "$HOME/.config/scripts/rofi/bluetooth.sh";
            tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
            tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "{device_alias}\n{device_address}";
            tooltip-format-enumerate-connected-battery = "{device_alias}\n{device_address}\n{device_battery_percentage}%";
          };

          # ─── Power ─────────────────────────────────────────────
          "custom/power" = {
            format = "";
            interval = 86400;
            on-click = "wlogout";
            rotate = 0;
            tooltip = false;
          };

          # ─── Notifications ─────────────────────────────────────
          "custom/notification" = {
            escape = true;
            exec = "swaync-client -swb";
            exec-if = "which swaync-client";
            format = "{icon}";
            format-icons = {
              dnd-inhibited-none = "<span foreground='#ea6962'></span>";
              dnd-inhibited-notification = "<span foreground='#ea6962'></span>";
              dnd-none = "<span foreground='#ea6962'></span>";
              dnd-notification = "<span foreground='#ea6962'></span>";
              inhibited-none = "";
              inhibited-notification = "";
              none = "";
              notification = "󰅸";
            };
            on-click = "swaync-client -t -sw";
            on-click-right = "swaync-client -d -sw";
            return-type = "json";
            tooltip = false;
          };

          # ─── Custom Tools ──────────────────────────────────────
          "custom/screenshot" = {
            format = "󰄀";
            on-click = "bash -c $HOME/.config/scripts/snapshot.sh";
            tooltip = false;
          };

          "custom/colorpicker" = {
            format = "󰏘";
            on-click = "sleep 0.5 && hyprpicker | wl-copy";
            tooltip = false;
          };

          # ─── Expandable Group ──────────────────────────────────
          "group/expand" = {
            drawer = {
              click-to-reveal = true;
              transition-duration = 600;
              transition-to-left = true;
            };
            modules = [
              "custom/expand"
              "memory"
              "cpu"
              "disk"
              # "temperature"
              # "backlight"
              "custom/endpoint"
            ];
            orientation = "horizontal";
          };

          "custom/expand" = {
            format = "";
            tooltip = false;
          };

          "custom/endpoint" = {
            format = "|";
            tooltip = false;
          };

          # ─── Padding Modules ───────────────────────────────────
          "custom/l_end" = {
            format = " ";
            interval = "once";
            tooltip = false;
          };

          "custom/r_end" = {
            format = " ";
            interval = "once";
            tooltip = false;
          };

          "custom/sl_end" = {
            format = " ";
            interval = "once";
            tooltip = false;
          };

          "custom/sr_end" = {
            format = " ";
            interval = "once";
            tooltip = false;
          };

          "custom/rl_end" = {
            format = " ";
            interval = "once";
            tooltip = false;
          };

          "custom/rr_end" = {
            format = " ";
            interval = "once";
            tooltip = false;
          };

          "custom/padd" = {
            format = "  ";
            interval = "once";
            tooltip = false;
          };
        };
      };

      # Waybar CSS styling
      style = ''
        * {
          font-size: 15px;
          font-family: "CodeNewRoman Nerd Font Propo";
        }

        window#waybar {
          all: unset;
        }

        .modules-left {
          padding: 7px;
          margin: 5px;
          border-radius: 10px;
          background: rgba(40, 40, 40, 0.5);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, .5);
        }

        .modules-center {
          padding: 7px;
          margin: 5px;
          border-radius: 10px;
          background: rgba(40, 40, 40, 0.5);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, .5);
        }

        .modules-right {
          padding: 7px;
          margin: 5px;
          border-radius: 10px;
          background: rgba(40, 40, 40, 0.5);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, .5);
        }

        tooltip {
          background: #282828;
          color: #a89984;
        }

        #clock:hover,
        #custom-power:hover,
        #custom-notification:hover,
        #bluetooth:hover,
        #network:hover,
        #battery:hover,
        #cpu:hover,
        #memory:hover,
        #disk:hover,
        #temperature:hover,
        #backlight:hover,
        #custom-screenshot:hover,
                #custom-colorpicker:hover {
                transition: all .3s ease;
                color: #fb4934;
                }

        #custom-notification {
                padding: 0px 5px;
                transition: all .3s ease;
                color: #a89984;
                }

        #custom-power {
                padding: 0px 5px;
                transition: all .3s ease;
                color: #458588;
                }

        #clock {
                padding: 0px 5px;
                color: #a89984;
                transition: all .3s ease;
                }

        #tray {
                padding: 0px 5px;
                transition: all .3s ease;
                color: #a89984;
                }

        #workspaces {
                padding: 0px 5px;
                }

        #workspaces button {
                all: unset;
                padding: 0px 5px;
                color: rgba(251, 73, 52, 0.4);
                transition: all .2s ease;
                }

        #workspaces button:hover {
                color: rgba(0, 0, 0, 0);
                border: none;
                text-shadow: 0px 0px 1.5px rgba(0, 0, 0, .5);
                transition: all 1s ease;
                }

        #workspaces button.active {
                color: #fb4934;
                border: none;
                text-shadow: 0px 0px 2px rgba(0, 0, 0, .5);
                }

        #workspaces button.empty {
                color: rgba(0, 0, 0, 0);
                border: none;
                text-shadow: 0px 0px 1.5px rgba(0, 0, 0, .2);
                }

        #workspaces button.empty:hover {
                color: rgba(0, 0, 0, 0);
                border: none;
                text-shadow: 0px 0px 1.5px rgba(0, 0, 0, .5);
                transition: all 1s ease;
                }

        #workspaces button.empty.active {
                color: #fb4934;
                border: none;
                text-shadow: 0px 0px 2px rgba(0, 0, 0, .5);
                }

        #bluetooth {
                padding: 0px 5px;
                transition: all .3s ease;
                color: #a89984;

                }

        #network {
                padding: 0px 5px;
                transition: all .3s ease;
                color: #a89984;

                }

        #mpris {
          padding: 0px 5px;
          transition: all .3s ease;
          color: #a89984;
        }

        #mpris.playing {
          color: #b8bb26;
        }

        #mpris.paused {
          color: #a89984;
        }

        #mpris:hover {
          color: #fb4934;
        }

        #pulseaudio {
                padding: 0px 5px;
                transition: all .3s ease;
                color: #a89984;

                }

        #battery {
                padding: 0px 5px;
                transition: all .3s ease;
                color: #a89984;

                }

        #battery.charging {
                color: #b8bb26;
                }

        #battery.warning:not(.charging) {
                color: #fabd2f;
                }

        #battery.critical:not(.charging) {
                color: #fb4934;
                animation-name: blink;
                animation-duration: 0.5s;
                animation-timing-function: linear;
                animation-iteration-count: infinite;
                animation-direction: alternate;
                }

        #group-expand {
                padding: 0px 5px;
                transition: all .3s ease;
                }

        #custom-expand {
                padding: 0px 5px;
                color: rgba(235, 219, 178, 0.2);
                text-shadow: 0px 0px 2px rgba(0, 0, 0, .7);
                transition: all .3s ease;
                }

        #custom-expand:hover {
                color: rgba(255, 255, 255, .2);
                text-shadow: 0px 0px 2px rgba(255, 255, 255, .5);
                }

        #custom-colorpicker {
                padding: 0px 5px;
                }

        #cpu,
        #memory,
        #disk,
        #temperature,
        #backlight,
        #custom-screenshot,
        #custom-colorpicker {
                padding: 0px 5px;
                transition: all .3s ease;
                color: #a89984;

                }

        #custom-endpoint {
                color: transparent;
                text-shadow: 0px 0px 1.5px rgba(0, 0, 0, 1);

                }

        #tray {
                padding: 0px 5px;
                transition: all .3s ease;

                }

        #tray menu * {
                padding: 0px 5px;
                transition: all .3s ease;
                }

        #tray menu separator {
                padding: 0px 5px;
                transition: all .3s ease;
                }
        #custom-weather {
          padding: 0px 5px;
          transition: all .3s ease;
          color: #a89984;
          }

        #custom-weather:hover {
          transition: all .3s ease;
          color: #fb4934;
          }

        #custom-weather.weather-error {
          color: #fb4934;
          }
      '';
    };
  };
}
