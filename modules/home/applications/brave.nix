{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.features.application.brave = {
    enable = mkEnableOption "Enable Brave browser";

    defaultBrowser = mkOption {
      type = types.bool;
      default = false;
      description = "Set Brave as the default browser";
    };
  };

  config = mkIf config.features.application.brave.enable {
    home.packages = [ pkgs.brave ];

    # Only set as default if defaultBrowser = true
    xdg.mimeApps = mkIf config.features.application.brave.defaultBrowser {
      enable = true;
      defaultApplications = {
        "text/html" = [ "brave-browser.desktop" ];
        "x-scheme-handler/http" = [ "brave-browser.desktop" ];
        "x-scheme-handler/https" = [ "brave-browser.desktop" ];
      };
    };

    # Optional: add desktop entry
    xdg.desktopEntries.brave = mkIf config.features.application.brave.defaultBrowser {
      name = "Brave Browser";
      genericName = "Web Browser";
      exec = "brave %U";
      icon = "brave-browser";
      categories = [
        "Network"
        "WebBrowser"
      ];
      mimeType = [
        "text/html"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
    };
  };
}
