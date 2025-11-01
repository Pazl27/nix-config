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

      # Hilfspakete
      gvfs
      file-roller
    ];

    xdg.mimeApps.defaultApplications = {
      "inode/directory" = "thunar.desktop";
    };

    # Thunar-Hintergrunddienste (optional)
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
