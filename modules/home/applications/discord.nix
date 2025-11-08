{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.features.application.discord = {
    enable = mkEnableOption "Discord Configuration with Vencord and Gruvbox theme";
  };

  config = mkIf config.features.application.discord.enable {
    # Install Discord with Vencord
    home.packages = [
      (pkgs.discord.override {
        withVencord = true;
      })
    ];

    # Vencord settings with Gruvbox theme
    xdg.configFile."Vencord/settings/settings.json" = {
      force = true; # Add this
      text = builtins.toJSON {
        notifyAboutUpdates = true;
        autoUpdate = false;
        autoUpdateNotification = true;
        useQuickCss = true;
        themeLinks = [
          "https://raw.githubusercontent.com/LuckieLuke/CSS-Themes/main/Gruvbox/import.css"
        ];
        enabledThemes = [
          "Gruvbox.theme.css"
        ];

        plugins = {
          BadgeAPI.enabled = true;
          CommandsAPI.enabled = true;
          MemberCount.enabled = true;
          MessageLogger.enabled = true;
          MoreUserTags.enabled = true;
          NoTrack.enabled = true;
          Settings.enabled = true;
          SupportHelper.enabled = true;
        };
      };
    };
  };
}
