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
      thunar
      thunar-volman
      thunar-archive-plugin
      thunar-media-tags-plugin

      # File management
      file-roller

      # Thumbnails
      tumbler
      ffmpegthumbnailer
      libgsf

      # Image viewer
      nsxiv

    ];

    services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "auto";
    };

    # Ensure thumbnail cache directory exists and persists
    xdg.cacheHome = "${config.home.homeDirectory}/.cache";

    # Tumbler config to ensure it saves thumbnails
    xdg.configFile."tumbler/tumbler.rc".text = ''
      [General]
      MaxFileSize=1073741824

      [DesktopThumbnailer]
      Disabled=false

      [GstVideoThumbnailer]
      Disabled=false

      [FFMpegThumbnailer]
      Disabled=false

      [PopplerThumbnailer]
      Disabled=false

      [PixbufThumbnailer]
      Disabled=false
    '';

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        # Directories
        "inode/directory" = "thunar.desktop";
        "application/x-directory" = "thunar.desktop";

        # PDFs
        "application/pdf" = "org.kde.okular.desktop";

        # Images
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

        # Videos
        "video/mp4" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop";
        "video/x-msvideo" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/quicktime" = "mpv.desktop";
        "video/mpeg" = "mpv.desktop";
      };
    };

    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
