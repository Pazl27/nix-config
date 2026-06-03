{ ... }:
''
  // Global: rounded corners for all windows
  window-rule {
      geometry-corner-radius 20
      clip-to-geometry true
  }

  // ── Blur ─────────────────────────────────────────────────────────────

  window-rule {
      match app-id=r#"^com\.mitchellh\.ghostty$"#
      background-effect {
          blur true
          xray false
          noise 0.05
      }
  }

  window-rule {
      match app-id=r#"^kitty$"#
      background-effect {
          blur true
          xray false
          noise 0.05
      }
  }

  // ── Terminals ────────────────────────────────────────────────────────

  window-rule {
      match app-id=r#"^floating-kitty$"#
      open-floating true
      default-column-width { fixed 1000; }
      default-window-height { fixed 700; }
  }

  window-rule {
      match app-id=r#"^dropterm$"#
      open-floating true
      default-column-width { fixed 1300; }
      default-window-height { fixed 875; }
  }

  // ── File managers ────────────────────────────────────────────────────

  // Thunar: opacity makes the blur visible (GTK3 is opaque by default)
  window-rule {
      match app-id=r#"^[Tt]hunar$"#
      open-floating true
      default-column-width { fixed 1000; }
      default-window-height { fixed 800; }
      opacity 0.88
      background-effect {
          blur true
          xray false
          noise 0.05
      }
  }

  window-rule {
      match app-id=r#"^org\.gnome\.FileRoller$"#
      open-floating true
  }

  window-rule {
      match app-id=r#"^xdg-desktop-portal-gtk$"#
      open-floating true
      default-column-width { fixed 1000; }
      default-window-height { fixed 800; }
  }

  // ── Media ────────────────────────────────────────────────────────────

  window-rule {
      match app-id=r#"firefox$"# title="^Picture-in-Picture$"
      open-floating true
  }

  window-rule {
      match app-id=r#"^[Nn]sxiv$"#
      open-floating true
      default-column-width { fixed 1000; }
      default-window-height { fixed 800; }
  }

  layer-rule {
      match namespace="^noctalia-(background|launcher-overlay|dock)-.*$"
      background-effect {
          xray false
      }
  }

  // ── Productivity ─────────────────────────────────────────────────────

  window-rule {
      match app-id=r#"^com\.obsproject\.Studio$"#
      default-column-width { proportion 0.7; }
  }

  window-rule {
      match app-id=r#"[Kk]ee[Pp]ass"#
      open-floating true
      default-column-width { fixed 1000; }
      default-window-height { fixed 600; }
  }

  window-rule {
      match app-id=r#"^KeePass2$"# title="^Open Database"
      default-column-width { fixed 550; }
      default-window-height { fixed 300; }
  }

  window-rule {
      match app-id=r#"^askai$"#
      open-floating true
      default-column-width { fixed 1300; }
      default-window-height { fixed 875; }
  }

  window-rule {
      match app-id=r#"^installer$"#
      open-floating true
      default-column-width { fixed 1300; }
      default-window-height { fixed 875; }
  }

  // ── JetBrains IDEs ───────────────────────────────────────────────────

  window-rule {
      match app-id=r#"^jetbrains-clion$"# title="^Welcome to CLion$"
      open-floating true
  }

  window-rule {
      match app-id=r#"^jetbrains-idea$"# title="^Welcome to IntelliJ IDEA$"
      open-floating true
  }

  window-rule {
      match app-id=r#"^jetbrains-rustrover$"# title="^Welcome to RustRover$"
      open-floating true
  }

  // ── System utilities ─────────────────────────────────────────────────

  window-rule {
      match app-id=r#"^blueman"#
      open-floating true
      default-column-width { fixed 1300; }
      default-window-height { fixed 875; }
  }

  window-rule {
      match app-id=r#"^nm-connection-editor$"#
      open-floating true
      default-column-width { fixed 600; }
      default-window-height { fixed 400; }
  }

  window-rule {
      match app-id=r#"pavucontrol"#
      open-floating true
      default-column-width { fixed 500; }
      default-window-height { fixed 400; }
  }

  window-rule {
      match app-id=r#"^org\.gnome\.Calculator$"#
      open-floating true
  }

  window-rule {
      match app-id=r#"^Emulator$"#
      open-floating true
  }

  // ── Steam ────────────────────────────────────────────────────────────

  window-rule {
      match app-id=r#"^steam$"# title=r#"^(Friends List|Steam Settings|Settings|Screenshot Manager)$"#
      open-floating true
  }

  window-rule {
      match app-id=r#"^steam$"# title=r#".* - (Chat|event|News|Community|Properties)$"#
      open-floating true
  }

  window-rule {
      match title="^Select what to share$"
      open-floating true
  }

  // ── Misc workarounds ─────────────────────────────────────────────────

  window-rule {
      match app-id=r#"^org\.wezfurlong\.wezterm$"#
      default-column-width {}
  }

  // ── Layer rules ──────────────────────────────────────────────────────

  layer-rule {
      match namespace="^rofi$"
      shadow {
          on
      }
  }

  // Set the overview wallpaper on the backdrop.
  layer-rule {
      match namespace="^noctalia-overview*"
      place-within-backdrop true
  }

  debug {
      honor-xdg-activation-with-invalid-serial
  }
''
