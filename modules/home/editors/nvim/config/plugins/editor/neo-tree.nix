{
  plugins.neo-tree = {
    enable = true;

    settings = {
      sources = [
        "filesystem"
        "buffers"
        "git_status"
        "document_symbols"
      ];
      add_blank_line_at_top = false;

      filesystem = {
        bind_to_cwd = false;
        follow_current_file = {
          enabled = true;
        };
        filtered_items = {
          visible = true; # This makes hidden files visible by default
          hide_dotfiles = false;
          hide_gitignored = false;
          hide_hidden = false; # only works on Windows for hidden files/directories
          hide_by_name = [
            # ".DS_Store"
            # "thumbs.db"
          ];
          hide_by_pattern = [
            # "*.meta"
            # "*/src/*/tsconfig.json"
          ];
          always_show = [ # remains visible even if other settings would normally hide it
            ".gitignored"
            ".env"
            ".envrc"
          ];
          never_show = [ # remains hidden even if visible is toggled or other settings would show it
            # ".DS_Store"
            # "thumbs.db"
          ];
          never_show_by_pattern = [ # uses glob style patterns
            # ".null-ls_*"
          ];
        };
      };

      default_component_configs = {
        indent = {
          with_expanders = true;
          expander_collapsed = "󰅂";
          expander_expanded = "󰅀";
          expander_highlight = "NeoTreeExpander";
        };

        git_status = {
          symbols = {
            added = " ";
            conflict = "󰩌 ";
            deleted = "󱂥";
            ignored = " ";
            modified = " ";
            renamed = "󰑕";
            staged = "󰩍";
            unstaged = "";
            untracked = " ";
          };
        };
      };
    };
  };

  keymaps = [
    {
      mode = [ "n" ];
      key = "<leader>e";
      action = "<cmd>Neotree toggle<cr>";
      options = {
        desc = "Open/Close Neotree";
      };
    }
    {
      mode = [ "n" ];
      key = "<leader>H";
      action = "<cmd>Neotree toggle show_hidden<cr>";
      options = {
        desc = "Toggle hidden files in Neotree";
      };
    }
  ];
}
