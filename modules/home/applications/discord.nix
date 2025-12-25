{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.features.application.discord = {
    enable = mkEnableOption "Discord Configuration with Vencord and system24 Gruvbox theme";
  };
  config = mkIf config.features.application.discord.enable {
    # Install Discord with Vencord
    home.packages = [
      (pkgs.discord.override {
        withVencord = true;
      })
    ];
    # Vencord settings with system24 theme
    xdg.configFile."Vencord/settings/settings.json" = {
      force = true;
      text = builtins.toJSON {
        notifyAboutUpdates = true;
        autoUpdate = false;
        autoUpdateNotification = true;
        useQuickCss = true;
        themeLinks = [
          "https://refact0r.github.io/system24/theme/system24.theme.css"
        ];
        enabledThemes = [
          "system24.theme.css"
        ];
        plugins = {
          BadgeAPI.enabled = true;
          ReadAllNotificationsButton.enabled = true;
          FakeNitro.enabled = true;
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

    # Custom CSS for system24 Gruvbox theme
    xdg.configFile."Vencord/settings/quickCss.css" = {
      force = true;
      text = ''
        /**
         * @name system24 (gruvbox)
         * @description Override system24 v2.0 with Gruvbox colors
         */

        /* IMPORT THE BASE THEME FIRST */
        @import url('https://refact0r.github.io/system24/build/system24.css');

        /* SETTINGS OVERRIDES */
        /* We use 'body' to match the theme's specificity for settings */
        body {
              --font: 'JetBrains Mono';
              --code-font: 'JetBrains Mono';
              --font-weight: 400; 
              --letter-spacing: -0.05ch;

              --gap: 12px;
              --divider-thickness: 4px;
              --border-thickness: 2px;
              
              --panel-labels: on;
              --label-font-weight: 500;
              --ascii-titles: on;
              --ascii-loader: system24;
        }

        /* COLOR OVERRIDES */
        /* Using "html:root" gives this block higher priority (specificity) 
        than the standard ":root" used in the imported theme.
        */
        html:root {
            /* Gruvbox Palette Map */
            
            /* Text Colors */
            --text-0: #1d2021; /* bg-4 */
            --text-1: #fbf1c7; /* light 1 */
            --text-2: #ebdbb2; /* light 2 */
            --text-3: #d5c4a1; /* light 3 */
            --text-4: #bdae93; /* light 4 */
            --text-5: #928374; /* gray */

            /* Backgrounds */
            --bg-1: #504945;
            --bg-2: #3c3836;
            --bg-3: #282828;
            --bg-4: #1d2021;
            
            /* Interactions */
            --hover: hsla(27, 25%, 35%, 0.3);
            --active: var(--bg-1);
            --active-2: #665c54;
            --message-hover: var(--hover);

            /* Accents (Orange/Gruvbox Focus) */
            --accent-1: #fe8019;
            --accent-2: #fe8019;
            --accent-3: #fe8019;
            --accent-4: #d65d0e;
            --accent-5: #af3a03;
            --accent-new: #fb4934;

            /* Advanced Colors (Gradients & Status) */
            --mention: linear-gradient(to right, color-mix(in hsl, var(--accent-2), transparent 90%) 40%, transparent);
            --mention-hover: linear-gradient(to right, color-mix(in hsl, var(--accent-2), transparent 95%) 40%, transparent);
            --reply: linear-gradient(to right, color-mix(in hsl, var(--text-3), transparent 90%) 40%, transparent);
            --reply-hover: linear-gradient(to right, color-mix(in hsl, var(--text-3), transparent 95%) 40%, transparent);

            --online: #b8bb26;
            --dnd: #fb4934;
            --idle: #fabd2f;
            --streaming: #d3869b;
            --offline: var(--text-4);

            --border-light: var(--hover);
            --border: var(--active);
            --border-hover: var(--accent-2);
            --button-border: hsla(27, 25%, 70%, 0.1);

            /* Full Palette Definition */
            --red-1: #fb4934; --red-2: #cc241d; --red-3: #9d0006; --red-4: #cc241d; --red-5: #9d0006;
            --green-1: #b8bb26; --green-2: #98971a; --green-3: #79740e; --green-4: #98971a; --green-5: #79740e;
            --blue-1: #83a598; --blue-2: #458588; --blue-3: #076678; --blue-4: #458588; --blue-5: #076678;
            --yellow-1: #fabd2f; --yellow-2: #d79921; --yellow-3: #b57614; --yellow-4: #d79921; --yellow-5: #b57614;
            --purple-1: #d3869b; --purple-2: #b16286; --purple-3: #8f3f71; --purple-4: #b16286; --purple-5: #8f3f71;
            --orange-1: #fe8019; --orange-2: #d65d0e; --orange-3: #af3a03;
        }
      '';
    };
  };
}
