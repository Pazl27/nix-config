{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.features.application.firefox = {
    enable = mkEnableOption "Enable Firefox with Textfox customization";
    default = mkOption {
      type = types.bool;
      default = false;
      description = "Set Firefox as the default browser";
    };
  };

  config = mkIf config.features.application.firefox.enable {
    programs.firefox = {
      enable = true;
      profiles."default" = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          # Disable pocket
          "extensions.pocket.enabled" = false;
          # Hardware acceleration
          "gfx.webrender.all" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          # Privacy settings
          "privacy.trackingprotection.enabled" = true;
          "dom.security.https_only_mode" = true;
          # UI tweaks for Textfox
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.tabs.drawInTitlebar" = true;
          "svg.context-properties.content.enabled" = true;
          # Smooth scrolling
          "general.smoothScroll" = true;
          # Disable Firefox View
          "browser.tabs.firefox-view" = false;
        };
      };
    };

    textfox = {
      enable = true;
      profile = "default";
      config = {
        # Gruvbox Dark Hard background
        background = {
          color = "#1d2021";
        };
        # Gruvbox orange border
        border = {
          color = "#fe8019";
          width = "2px";
          transition = "0.2s ease";
          radius = "8px";
        };
        displayHorizontalTabs = false;
        displayWindowControls = true;
        displayNavButtons = true;
        displayUrlbarIcons = true;
        displaySidebarTools = true;
        displayTitles = true;
        font = {
          family = "JetBrains Mono";
          size = "14px";
          accent = "#fe8019";
        };
        sidebery = {
          margin = "0.8rem";
        };
        newtabLogo = "   ____                 _                \A  / ___|_ __ _   ___   _| |__   _____  __\A | |  _| '__| | | \\ \\ / / '_ \\ / _ \\ \\/ /\A | |_| | |  | |_| |\\ V /| |_) | (_) >  < \A  \\____|_|   \\__,_| \\_/ |_.__/ \\___/_/\\_\\";
      };
    };

    # Set as default browser
    xdg.mimeApps = mkIf config.features.application.firefox.default {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
      };
    };

    # Set environment variable
    home.sessionVariables = mkIf config.features.application.firefox.default {
      BROWSER = "firefox";
    };
  };
}
