{ ... }:
''
  spawn-at-startup "noctalia-shell"
  spawn-at-startup "wl-paste" "--type" "text" "--watch" "cliphist" "store"
  spawn-at-startup "wl-paste" "--type" "image" "--watch" "cliphist" "store"

  hotkey-overlay {
      skip-at-startup
  }
''
