{
  plugins.trouble = {
    enable = true;

    settings = {
      # Use devicons
      use_diagnostic_signs = true;

      # Position and layout
      position = "bottom";
      height = 10;
      width = 50;

      # Auto close when empty
      auto_close = false;
      auto_preview = true;
      auto_fold = false;

      # Styling
      indent_lines = true;
      signs = {
        error = "";
        warning = "";
        hint = "";
        information = "";
        other = "";
      };

      # Add keymaps for trouble window
      keys = {
        "<esc>" = "close";
        q = "close";
        "<cr>" = "jump_close";
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<cr>";
      options = {
        desc = "Diagnostics (Trouble)";
      };
    }
    {
      mode = "n";
      key = "<leader>xX";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
      options = {
        desc = "Buffer Diagnostics (Trouble)";
      };
    }
    {
      mode = "n";
      key = "<leader>xs";
      action = "<cmd>Trouble symbols toggle focus=false<cr>";
      options = {
        desc = "Symbols (Trouble)";
      };
    }
    {
      mode = "n";
      key = "<leader>xl";
      action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
      options = {
        desc = "LSP Definitions / references / ... (Trouble)";
      };
    }
    {
      mode = "n";
      key = "<leader>xL";
      action = "<cmd>Trouble loclist toggle<cr>";
      options = {
        desc = "Location List (Trouble)";
      };
    }
    {
      mode = "n";
      key = "<leader>xQ";
      action = "<cmd>Trouble qflist toggle<cr>";
      options = {
        desc = "Quickfix List (Trouble)";
      };
    }
    # Override grr to use Trouble for references
    {
      mode = "n";
      key = "grr";
      action = "<cmd>Trouble lsp_references toggle<cr>";
      options = {
        desc = "LSP References (Trouble)";
      };
    }
    # Navigate between trouble items
    {
      mode = "n";
      key = "[t";
      action = ''<cmd>lua require("trouble").prev({skip_groups = true, jump = true})<cr>'';
      options = {
        desc = "Previous Trouble Item";
      };
    }
    {
      mode = "n";
      key = "]t";
      action = ''<cmd>lua require("trouble").next({skip_groups = true, jump = true})<cr>'';
      options = {
        desc = "Next Trouble Item";
      };
    }
  ];
}
