{ ... }:
''
  // Start up Commands

  spawn-at-startup "waybar"
  spawn-at-startup "swww-daemon"
  spawn-at-startup "wl-paste" "--type" "text" "--watch" "cliphist" "store"
  spawn-at-startup "wl-paste" "--type" "image" "--watch" "cliphist" "store"

  // To run a shell command (with variables, pipes, etc.), use spawn-sh-at-startup:
  // spawn-sh-at-startup "qs -c ~/source/qs/MyAwesomeShell"

  hotkey-overlay {
      // Uncomment this line to disable the "Important Hotkeys" pop-up at startup.
  skip-at-startup
  }

''
