{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.features.application.zathura = {
    enable = mkEnableOption "Zathura PDF viewer with Gruvbox light theme";
  };

  config = mkIf config.features.application.zathura.enable {
    programs.zathura = {
      enable = true;

      options = {
        # Gruvbox Light color scheme
        # Background and foreground
        default-bg = "#fbf1c7";
        default-fg = "#3c3836";

        # Statusbar colors
        statusbar-bg = "#ebdbb2";
        statusbar-fg = "#3c3836";

        # Inputbar colors
        inputbar-bg = "#fbf1c7";
        inputbar-fg = "#3c3836";

        # Notification colors
        notification-bg = "#fbf1c7";
        notification-fg = "#3c3836";
        notification-error-bg = "#fbf1c7";
        notification-error-fg = "#cc241d";
        notification-warning-bg = "#fbf1c7";
        notification-warning-fg = "#d79921";

        # Highlight colors
        highlight-color = "#d79921";
        highlight-active-color = "#458588";

        # Completion colors
        completion-bg = "#ebdbb2";
        completion-fg = "#3c3836";
        completion-highlight-bg = "#d5c4a1";
        completion-highlight-fg = "#3c3836";
        completion-group-bg = "#ebdbb2";
        completion-group-fg = "#3c3836";

        # Recolor (for better readability)
        # Text and background get Gruvbox colors, but images keep their original colors
        recolor = true;
        recolor-lightcolor = "#fbf1c7";
        recolor-darkcolor = "#3c3836";
        recolor-keephue = true;

        # Index colors
        index-bg = "#fbf1c7";
        index-fg = "#3c3836";
        index-active-bg = "#d5c4a1";
        index-active-fg = "#3c3836";

        # Additional settings
        font = "JetBrainsMono 11";
        selection-clipboard = "clipboard";
        adjust-open = "best-fit";
        pages-per-row = 1;
        scroll-page-aware = true;
        scroll-full-overlap = "0.01";
        scroll-step = 100;
        zoom-min = 10;
        guioptions = "none";
      };

      extraConfig = ''
        # Additional keybindings
        map <C-i> recolor
        map p print
      '';
    };
  };
}
