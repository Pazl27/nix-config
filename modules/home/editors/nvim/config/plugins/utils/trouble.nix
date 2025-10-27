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
      key = "<leader>cs";
      action = "<cmd>Trouble symbols toggle focus=false<cr>";
      options = {
        desc = "Symbols (Trouble)";
      };
    }
    {
      mode = "n";
      key = "<leader>cl";
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
  ];
}
