{
  plugins.actions-preview = {
    enable = true;
    settings = {
      # Use telescope for the interface
      telescope = {
        sorting_strategy = "ascending";
        layout_strategy = "vertical";
        layout_config = {
          width = 0.8;
          height = 0.9;
          prompt_position = "top";
          preview_cutoff = 20;
          preview_height = {
            __raw = ''
              function(_, _, max_lines)
                return max_lines - 15
              end
            '';
          };
        };
      };

      # Highlight configuration for better diff preview
      highlight_command = [
        {
          __raw = ''require('actions-preview.highlight').diff_so_fancy()'';
        }
        {
          __raw = ''require('actions-preview.highlight').diff_highlight()'';
        }
      ];

      # Backend priority (telescope first, then nui, then builtin)
      backend = [ "telescope" "nui" ];

      # Diff configuration
      diff = {
        algorithm = "patience";
        ignore_whitespace = true;
      };
    };
  };

  # Override the default LSP code action keymap to use actions-preview
  keymaps = [
    {
      mode = "n";
      key = "<leader>ca";
      action = "<cmd>lua require('actions-preview').code_actions()<cr>";
      options = {
        desc = "Code Actions Preview";
        silent = true;
      };
    }
    {
      mode = "v";
      key = "<leader>ca";
      action = "<cmd>lua require('actions-preview').code_actions()<cr>";
      options = {
        desc = "Code Actions Preview";
        silent = true;
      };
    }
  ];
}
