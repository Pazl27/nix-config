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

      # Floating window configuration
      window = {
        position = "float";
        popup = {
          size = {
            height = "80%";
            width = "80%";
          };
          position = "50%";
        };
      };

      filesystem = {
        bind_to_cwd = false;
        follow_current_file = {
          enabled = true;
          leave_dirs_open = true;
        };
        filtered_items = {
          visible = true;
          hide_dotfiles = false;
          hide_gitignored = false;
          hide_hidden = false;
          hide_by_name = [ ];
          hide_by_pattern = [ ];
          always_show = [
            ".gitignored"
            ".env"
            ".envrc"
          ];
          never_show = [ ];
          never_show_by_pattern = [ ];
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
      key = "<leader>E";
      action = "<cmd>Neotree toggle float<cr>";
      options = {
        desc = "Toggle Neotree (Floating)";
      };
    }
    {
      mode = [ "n" ];
      key = "<leader>e";
      action = "<cmd>Neotree toggle left<cr>";
      options = {
        desc = "Toggle Neotree (Sidebar)";
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
