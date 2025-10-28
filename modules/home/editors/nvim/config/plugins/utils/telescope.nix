{
  plugins.telescope = {
    enable = true;
    extensions = {
      file-browser = {
        enable = true;
      };
      fzf-native = {
        enable = true;
      };
    };
    settings = {
      defaults = {
        layout_config = {
          horizontal = {
            prompt_position = "top";
          };
        };
        sorting_strategy = "ascending";

        # Custom mappings for telescope windows
        mappings = {
          i = {
            # Close telescope with single escape (instead of going to normal mode first)
            "<esc>" = "close";
            # Navigate with Ctrl+J/K in insert mode
            "<C-j>" = "move_selection_next";
            "<C-k>" = "move_selection_previous";
            # Keep default navigation as well
            "<Down>" = "move_selection_next";
            "<Up>" = "move_selection_previous";
          };
          n = {
            # Also ensure escape closes in normal mode
            "<esc>" = "close";
            # Standard vim navigation in normal mode
            "j" = "move_selection_next";
            "k" = "move_selection_previous";
          };
        };
      };
    };
    keymaps = {
      "<leader>:" = {
        action = "command_history";
        options = {
          desc = "Command History";
        };
      };
      "<leader>ff" = {
        action = "find_files";
        options = {
          desc = "Find project files";
        };
      };
      "<leader>fg" = {
        action = "live_grep";
        options = {
          desc = "Find text";
        };
      };
      "<leader>fb" = {
        action = "buffers";
        options = {
          desc = "Buffers";
        };
      };
      "<leader>fc" = {
        action = "git_commits";
        options = {
          desc = "Commits";
        };
      };
      "<leader>fs" = {
        action = "git_status";
        options = {
          desc = "Status";
        };
      };
      "<leader>sc" = {
        action = "command_history";
        options = {
          desc = "Command History";
        };
      };
      "<leader>sC" = {
        action = "commands";
        options = {
          desc = "Commands";
        };
      };
      "<leader>xD" = {
        action = "diagnostics";
        options = {
          desc = "Telescope Workspace diagnostics";
        };
      };
      "<leader>sk" = {
        action = "keymaps";
        options = {
          desc = "Keymaps";
        };
      };
      "<leader>sM" = {
        action = "man_pages";
        options = {
          desc = "Man pages";
        };
      };
      "<leader>so" = {
        action = "vim_options";
        options = {
          desc = "Options";
        };
      };
      "<leader>uC" = {
        action = "colorscheme";
        options = {
          desc = "Colorscheme preview";
        };
      };
    };
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>xd";
      action = "<cmd>Telescope diagnostics bufnr=0<cr>";
      options = {
        desc = "Telescope Document diagnostics";
      };
    }
    {
      mode = "n";
      key = "<leader>fe";
      action = "<cmd>Telescope file_browser<cr>";
      options = {
        desc = "File browser";
      };
    }
    {
      mode = "n";
      key = "<leader>fE";
      action = "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>";
      options = {
        desc = "File browser";
      };
    }
  ];
  extraConfigLua = ''
    require("telescope").setup{
      pickers = {
        colorscheme = {
          enable_preview = true
        }
      }
    }
  '';
}
