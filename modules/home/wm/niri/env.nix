{ ... }:
''
  environment {
      // Wayland session identifiers
      XDG_SESSION_TYPE "wayland"
      XDG_CURRENT_DESKTOP "niri"
      XDG_SESSION_DESKTOP "niri"

      // Qt Wayland backend
      QT_QPA_PLATFORM "wayland"

      // Firefox native Wayland
      MOZ_ENABLE_WAYLAND "1"

      // Electron apps (VS Code, Discord, etc.)
      NIXOS_OZONE_WL "1"

      // XWayland display — needed for X11 apps (Steam, etc.)
      // With services.xserver.enable = true, X takes :0 so niri XWayland lands on :1
      DISPLAY ":1"
  }
''
