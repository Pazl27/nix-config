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
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "thunar.desktop";
        "application/x-directory" = "thunar.desktop";
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
