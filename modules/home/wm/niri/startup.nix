{ ... }:
''
  spawn-at-startup "noctalia"
  spawn-at-startup "wl-paste" "--type" "text" "--watch" "cliphist" "store"
  spawn-at-startup "wl-paste" "--type" "image" "--watch" "cliphist" "store"
  // Xwayland server on :1 (DISPLAY is set to :1 in env.kdl) for X11 apps.
  spawn-at-startup "xwayland-satellite" ":1"

  hotkey-overlay {
      skip-at-startup
  }
''
