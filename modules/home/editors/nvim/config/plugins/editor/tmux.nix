{
  plugins.tmux-navigator = {
    enable = true;
    settings = {
      disable_when_zoomed = 1;
      save_on_switch = 2;  # Save current file when switching
      no_wrap = 0;     # Allow wrapping around splits
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<C-h>";
      action = "<cmd>TmuxNavigateLeft<CR>";
      options = {
        desc = "Navigate to left split/pane";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<cmd>TmuxNavigateDown<CR>";
      options = {
        desc = "Navigate to bottom split/pane";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<cmd>TmuxNavigateUp<CR>";
      options = {
        desc = "Navigate to top split/pane";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<cmd>TmuxNavigateRight<CR>";
      options = {
        desc = "Navigate to right split/pane";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<C-\\>";
      action = "<cmd>TmuxNavigatePrevious<CR>";
      options = {
        desc = "Navigate to previous split/pane";
        silent = true;
      };
    }
  ];
}
