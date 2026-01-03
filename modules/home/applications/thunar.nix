{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.features.application.thunar = {
    enable = mkEnableOption "Thunar file manager with plugins";
  };

  config = mkIf config.features.application.thunar.enable {
    home.packages = with pkgs; [
      xfce.thunar
      xfce.thunar-volman
      xfce.thunar-archive-plugin
      xfce.thunar-media-tags-plugin

      # File management
      file-roller

      # Thumbnails
      xfce.tumbler
      ffmpegthumbnailer
      libgsf

      # Image viewer
      nsxiv

    ];

    # Services
    services = {
      # Auto-mounting
      udiskie = {
        enable = true;
        automount = true;
        notify = true;
        tray = "auto";
      };
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        # Directories
        "inode/directory" = "thunar.desktop";
        "application/x-directory" = "thunar.desktop";

        # PDFs - open with LibreOffice Draw
        "application/pdf" = "libreoffice-draw.desktop";

        # Images - open with nsxiv
        "image/png" = "nsxiv.desktop";
        "image/jpeg" = "nsxiv.desktop";
        "image/jpg" = "nsxiv.desktop";
        "image/gif" = "nsxiv.desktop";
        "image/bmp" = "nsxiv.desktop";
        "image/webp" = "nsxiv.desktop";
        "image/tiff" = "nsxiv.desktop";
        "image/svg+xml" = "nsxiv.desktop";
        "image/x-portable-pixmap" = "nsxiv.desktop";
        "image/x-portable-graymap" = "nsxiv.desktop";
        "image/x-portable-bitmap" = "nsxiv.desktop";
        "image/x-portable-anymap" = "nsxiv.desktop";

        # Videos - open with mpv
        "video/mp4" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop"; # mkv
        "video/x-msvideo" = "mpv.desktop"; # avi
        "video/webm" = "mpv.desktop";
        "video/quicktime" = "mpv.desktop"; # mov
        "video/mpeg" = "mpv.desktop";
      };
    };

    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };

    systemd.user.services.thunar-daemon = {
      Unit = {
        Description = "Thunar file manager daemon";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "dbus";
        BusName = "org.xfce.Thunar";
        ExecStart = "${pkgs.xfce.thunar}/bin/thunar --daemon";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    systemd.user.services.tumbler = {
      Unit = {
        Description = "Tumbler thumbnailing service";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.thumbnails.Thumbnailer1";
        ExecStart = "${pkgs.xfce.tumbler}/lib/tumbler-1/tumblerd";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
