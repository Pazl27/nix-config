_: {
  plugins.gitsigns = {
    enable = true;
    settings = {
      signs = {
        add = {
          text = " ";
        };
        change = {
          text = " ";
        };
        delete = {
          text = " ";
        };
        untracked = {
          text = "";
        };
        topdelete = {
          text = "󱂥 ";
        };
        changedelete = {
          text = "󱂧 ";
        };
      };
      current_line_blame = true;
      current_line_blame_opts = {
        delay = 400;
        ignore_whitespaces = false;
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>gp";
      action = "<cmd>Gitsigns preview_hunk<CR>";
      options = {
        desc = "Preview Hunk";
      };
    }
    {
      mode = "n";
      key = "<leader>gr";
      action = "<cmd>Gitsigns reset_hunk<CR>";
      options = {
        desc = "Reset Hunk";
      };
    }
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>Gitsigns blame<CR>";
      options = {
        desc = "View File Blame";
      };
    }
  ];
}
