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
      gvfs
      file-roller

      # Thumbnails
      ffmpegthumbnailer
    ];

    # MIME Types
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "thunar.desktop";
        "application/x-directory" = "thunar.desktop";
      };
    };

    # XDG User Dirs
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };

    # Thunar Daemon
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
  };
}
