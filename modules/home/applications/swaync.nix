{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.features.application.swaync = {
    enable = mkEnableOption "SwayNC notification center configuration";
  };

  config = mkIf config.features.application.swaync.enable {
    # SwayNC package
    home.packages = with pkgs; [
      swaynotificationcenter
      brightnessctl
      libnotify
      pulseaudio
    ];

    # SwayNC service and configuration via Home Manager
    services.swaync = {
      enable = true;

      settings = {
        "$schema" = "/etc/xdg/swaync/configSchema.json";
        positionX = "right";
        positionY = "top";
        layer = "overlay";
        control-center-layer = "top";
        layer-shell = true;
        cssPriority = "user";
        control-center-width = 380;
        control-center-height = 860;
        control-center-margin-top = 0;
        control-center-margin-bottom = 5;
        control-center-margin-right = 0;
        control-center-margin-left = 10;
        notification-window-width = 350;
        notification-icon-size = 48;
        notification-body-image-height = 160;
        notification-body-image-width = 200;
        timeout = 4;
        timeout-low = 2;
        timeout-critical = 6;
        fit-to-screen = false;
        keyboard-shortcuts = true;
        image-visibility = "when-available";
        transition-time = 200;
        hide-on-clear = false;
        hide-on-action = false;
        script-fail-notify = true;

        notification-visibility = {
          spotify = {
            state = "muted";
            urgency = "Low";
            app-name = "Spotify";
          };
        };

        widgets = [
          "label"
          "buttons-grid"
          "mpris"
          "title"
          "dnd"
          "notifications"
        ];

        widget-config = {
          title = {
            text = "Notifications";
            clear-all-button = true;
            button-text = "";
          };

          dnd = {
            text = "Do not disturb";
          };

          label = {
            max-lines = 1;
            text = "";
          };

          mpris = {
            image-size = 96;
            image-radius = 12;
            blacklist = [ "playerctld" ];
          };

          notifications = {
            clear-all-button = true;
          };

          buttons-grid = {
            actions = [
              {
                label = "";
                command = "sh -c '[[ $SWAYNC_TOGGLE_STATE == true ]] && pactl set-sink-mute @DEFAULT_SINK@ 1 || pactl set-sink-mute @DEFAULT_SINK@ 0'";
                type = "toggle";
                update-command = "sh -c '[[ $(pactl get-sink-mute @DEFAULT_SINK@) == *yes* ]] && echo true || echo false'";
              }
              {
                label = "󰍭";
                command = "sh -c '[[ $SWAYNC_TOGGLE_STATE == true ]] && pactl set-source-mute @DEFAULT_SOURCE@ 1 || pactl set-source-mute @DEFAULT_SOURCE@ 0'";
                type = "toggle";
                update-command = "sh -c '[[ $(pactl get-source-mute @DEFAULT_SOURCE@) == *yes* ]] && echo true || echo false'";
              }
              {
                label = "";
                command = "nm-connection-editor";
              }
              {
                label = "󰂯";
                command = "blueman-manager";
              }
              {
                label = "󰏘";
                command = "nwg-look";
              }
            ];
          };
        };
      };

      style = ''
        /* Gruvbox Colors */
        @define-color background     #282828;
        @define-color foreground     #ebdbb2;
        @define-color background-alt #3c3836;
        @define-color gray           #504945;
        @define-color red            #cc241d;
        @define-color bright-red     #fb4934;
        @define-color orange         #d65d0e;
        @define-color yellow         #fabd2f;
        @define-color green          #b8bb26;
        @define-color blue           #458588;
        @define-color purple         #b16286;
        @define-color aqua           #689d6a;
        @define-color text           @foreground;
        @define-color selected       @rednot;
        @define-color hover          @bright-red;
        @define-color urgent         @orange;

        * {
          color: @text;
          font-size: 14px;
          font-family: "JetBrainsMono Nerd Font Propo";
          transition: 200ms;
        }

      /* Avoid 'annoying' background */
      .blank-window {
        background: transparent;
      }

      /* Animations for stacked notifications */
      @keyframes fadeIn {
        0% {
          padding-left: 20px;
          margin-left: 50px;
          margin-right: 50px;
        }
        100% {
          padding: 0;
          margin: 0;
        }
      }

  .floating-notifications .notification {
    animation: fadeIn 0.5s ease-in-out;
  }

  /* ==========================
     FLOATING NOTIFICATIONS
 ============================== */

  .notification-row {
    outline: none;
    padding: 0px;

  }

.floating-notifications.background .notification-row .notification-background {
    background: alpha(@background, 0.95);
    box-shadow: 0 0 8px 0 rgba(0, 0, 0, 0.6);
    border: 2px solid @red;
    border-radius: 24px;
    margin: 5px;
    padding: 0;
  }

  .floating-notifications.background .notification-row .notification-background .notification {
background: transparent;
    padding: 6px;
    border-radius: 12px;
  }

.floating-notifications.background .notification-row .notification-background .notification.critical {
background: transparent;
    border: 2px solid @urgent;
    background: alpha(@red, 0.2);
  }

  .floating-notifications.background .notification-row .notification-background .notification .notification-content {
    margin: 14px;
  }

.floating-notifications.background .notification-row .notification-background .notification > *:last-child > * {
  min-height: 3.4em;
}

.floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action {
  border-radius: 8px;
  background-color: @background-alt;
  margin: 6px;

}

.floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action:hover {
    background-color: @hover;
      border: 1px solid @selected;
  }

  .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action:active {
    background-color: @selected;
      color: @background;
    }

  .notification-row .notification-background .notification .notification-content .app-icon {
    margin: 10px 20px 10px 0px;
  }

  .summary {
    font-weight: 800;
      font-size: 1rem;
      color: @foreground;
    }

.body {
    font-size: 0.8rem;
      color: @foreground;
    }

.floating-notifications.background .notification-row .notification-background .close-button {
    margin: 6px;
      padding: 2px;
      border-radius: 6px;
      background-color: @red;
      border: 1px solid transparent;
    }

.floating-notifications.background .notification-row .notification-background .close-button:hover {
    background-color: @hover;
      box-shadow: 0 0 4px @selected;
  }

  .floating-notifications.background .notification-row .notification-background .close-button:active {
    background-color: @selected;
      color: @background;
    }

.notification.critical progress {
    background-color: @urgent;
    }

.notification.low progress,
  .notification.normal progress {
    background-color: @selected;
    }

/* ==================
     CONTROL CENTER
 ==================== */

.control-center {
  background: alpha(@background, 0.95);
  border-radius: 24px;
  border: 2px solid @red;
  box-shadow: 0 0 10px 0 rgba(0, 0, 0, 0.6);
  padding: 12px;
  margin: 5px;
}

  /* Notifications in Control Center - RED TRANSPARENT */
  .control-center .notification-row .notification {
    background-color: alpha(@red, 0.4);
    border: 2px solid @red;
    border-radius: 16px;
    margin: 4px 0px;
    padding: 4px;
    box-shadow:none;
  }}

  .control-center .notification-row .notification-background:hover {
    background-color: transparent;
      border-radius: 16px;
      margin: 4px 0px;
      padding: 4px;
    }

.control-center .notification-row .notification-background .notification.critical {
    border: 2px solid @urgent;
    background: alpha(@urgent, 0.4);

  }

  .control-center .notification-row .notification-background .notification .notification-content {
    margin: 6px;
      padding: 8px 6px 2px 2px;

  }

  .control-center .notification-row .notification-background .notification > *:last-child > * {
    min-height: 3.4em;
    }

.control-center .notification-row .notification-background .notification > *:last-child > * .notification-action {
    background: @background-alt;
      color: @text;
      border-radius: 12px;
      margin: 6px;
      border: 1px solid transparent;
    }

.control-center .notification-row .notification-background .notification > *:last-child > * .notification-action:hover {
    background: @hover;
      border: 1px solid @selected;
  }

  .control-center .notification-row .notification-background .notification > *:last-child > * .notification-action:active {
    background-color: @selected;
      color: @background;
    }

/* Close buttons in Control Center */
.control-center .notification-row .notification-background .close-button {
    background: @red;
      border-radius: 6px;
      color: @text;
      margin: 6px;
      padding: 4px;
    }

.control-center .notification-row .notification-background .close-button:hover {
    background-color: @hover;
      box-shadow: 0 0 4px @selected;
  }

  .control-center .notification-row .notification-background .close-button:active {
    background-color: @selected;
      color: @background;
    }

/* Progress bars */
progressbar,
  progress,
  trough {
    border-radius: 12px;
    }

progressbar {
    background-color: @background-alt;
    }

progress {
    background-color: @selected;
    }

trough {
    background-color: @gray;
    }

trough highlight {
    background: @selected;
    }

/* Notification groups */
.notification-group {
    margin: 2px 8px 2px 8px;
all: unset;

  }

  .notification-group-headers {
    font-weight: bold;
      color: @text;
      letter-spacing: 2px;
    }

.notification-group-icon {
    color: @text;
    }

.notification-group-collapse-button,
  .notification-group-close-all-button {
    background: @background-alt;
      color: @text;
      margin: 4px;
      border-radius: 6px;
      padding: 4px;
      border: 1px solid transparent;
    }

.notification-group-collapse-button:hover {
    background: @blue;
      border: 1px solid @selected;
  }

  .notification-group-close-all-button:hover {
    background: @red;
      border: 1px solid @selected;
  }

  /* ============================================
     WIDGETS
 ============================================ */

  /* Widget Label */
  .widget-label {
    margin: 6px;
      font-size: 1.5rem;
      color: @selected;
      font-weight: bold;
    }

/* Title widget */
.widget-title {
    font-size: 1.2em;
      margin: 6px;
      padding: 10px;
    }

.widget-title > label {
    font-size: 1.5rem;
      color: @text;
      font-weight: bold;
    }

.widget-title button {
    background: @red;
      border-radius: 8px;
      padding: 4px 16px;
      border: 1px solid transparent;
    }

.widget-title button:hover {
    background-color: @hover;
      box-shadow: 0 0 4px @selected;
  }

  .widget-title button:active {
    background-color: @selected;
      color: @background;
    }

/* DND widget */
.widget-dnd {
    margin: 6px;
      padding: 10px;
      font-size: 1.2rem;
    }

.widget-dnd > switch {
    background: @background-alt;
      font-size: initial;
      border-radius: 20px;
      box-shadow: none;
      border: 2px solid @gray;
      padding: 2px;
    }

.widget-dnd > switch:hover {
    border-color: @selected;
    }

.widget-dnd > switch:checked {
    background: @green;
      border-color: @green;
    }

.widget-dnd > switch:checked:hover {
    background: alpha(@green, 0.8);
    }

.widget-dnd > switch slider {
    background: @foreground;
      border-radius: 16px;
      min-width: 18px;
      min-height: 18px;
    }

/* Buttons Grid widget */
.widget-buttons-grid {
  font-size: x-large;
  padding: 6px;
  margin: 6px;
  margin-top: -10px;
  border-radius: 12px;
  background: @background-alt;
}

.widget-buttons-grid > flowbox > flowboxchild {
  margin: 0;
  padding: 0;
}

.widget-buttons-grid > flowbox > flowboxchild > button {
  margin: 4px;
  padding: 8px;
  background: @background-alt;
  border-radius: 8px;
  border: 1px solid transparent;
  min-width: 45px;
  min-height: 45px;
}

.widget-buttons-grid > flowbox > flowboxchild > button label {
  font-size: 20px;  /* Add this - ensures consistent icon size */
}

.widget-buttons-grid > flowbox > flowboxchild > button:hover {
  background: @red;
  border: 1px solid @selected;
}

.widget-buttons-grid > flowbox > flowboxchild > button:active {
  background: @selected;
  color: @background;
}

.widget-buttons-grid > flowbox > flowboxchild > button.toggle:checked {
  background: @selected;
  border-color: @bright-red;
}

.widget-buttons-grid > flowbox > flowboxchild > button.toggle:checked:hover {
  background: @hover;
}


/* Music player */
.widget-mpris {
background: @background-alt;
border-radius: 16px;
color: @text;
margin:  20px 6px;
}

.widget-mpris-player {
border-radius: 22px;
padding: 6px 14px;
margin: 6px;
box-shadow:none;

border: 1px solid @background;
}
.widget-mpris-player > box {
background: transparent;

}

.widget-mpris > box > button {
color: @text;
border-radius: 20px;
}

.widget-mpris button {
color: alpha(@text, .6);
}

.widget-mpris button:hover {
color: @text;
}

.widget-mpris-album-art {
border-radius: 16px;
}

.widget-mpris-title {
font-weight: 700;
    font-size: 1rem;
    }

.widget-mpris-subtitle {
font-weight: 500;
   font-size: 0.8rem;
   }

/* Volume widget */
.widget-volume {
    background: @background-alt;
      color: @text;
      padding: 4px;
      margin: 6px;
      border-radius: 12px;
      border: 2px solid @gray;
    }

.widget-volume > box > button {
    border: none;
      background: transparent;
    }

.widget-volume > box > button:hover {
    background: @gray;
    }

.per-app-volume {
    padding: 4px 8px 8px 8px;
    margin: 0px 8px 8px 8px;
  }

  scale trough {
    margin: 0rem 1rem;
    background-color: @gray;
    min-height: 8px;
    min-width: 70px;
    border-radius: 8px;
  }

  slider {
    background-color: @selected;
      border-radius: 8px;
    }

tooltip {
    background-color: @background-alt;
      color: @foreground;
      border-radius: 8px;
      border: 1px solid @selected;
    }

    scrollbar {
      opacity: 0;
      }


      '';
    };
  };
}
