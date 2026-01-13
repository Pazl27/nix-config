{
  globals.mapleader = " ";

  keymaps = [
    # Better up/down movement for wrapped lines
    {
      mode = [
        "n"
        "x"
      ];
      key = "j";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = {
        expr = true;
        silent = true;
      };
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "<Down>";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = {
        expr = true;
        silent = true;
      };
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "k";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = {
        expr = true;
        silent = true;
      };
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "<Up>";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = {
        expr = true;
        silent = true;
      };
    }

    # Save keymaps (and reset highlights)
    {
      mode = "i";
      key = "<esc>";
      action = "<cmd>wa<cr><esc>";
      options = {
        desc = "Save all, clear highlights and escape";
      };
    }
    {
      mode = "n";
      key = "<esc>";
      action = "<cmd>wa | noh<cr>";
      options = {
        desc = "Save all and clear highlights";
      };
    }
    {
      mode = [
        "i"
        "x"
        "n"
        "s"
      ];
      key = "<C-s>";
      action = "<cmd>w<cr><esc>";
      options = {
        desc = "Save File";
      };
    }

    # Quit keymaps
    {
      mode = "n";
      key = "<leader>qa";
      action = "<cmd>qa<cr>";
      options = {
        desc = "Quit All";
      };
    }

    # Undo/Redo (your config)
    {
      mode = "n";
      key = "U";
      action = "<C-r>";
      options = {
        desc = "Redo";
      };
    }
    {
      mode = "x";
      key = "K";
      action = ":move '<-2<CR>gv=gv";
      options = {
        desc = "Move selection up";
        silent = true;
      };
    }
    {
      mode = "x";
      key = "J";
      action = ":move '>+1<CR>gv=gv";
      options = {
        desc = "Move selection down";
        silent = true;
      };
    }
    {
      mode = "x";
      key = "<Tab>";
      action = ">gv";
      options = {
        desc = "Indent selection";
        silent = true;
        noremap = true;
      };
    }
    {
      mode = "x";
      key = "<S-Tab>";
      action = "<gv";
      options = {
        desc = "Unindent selection";
        silent = true;
        noremap = true;
      };
    }
    {
      mode = "n";
      key = "<leader>xf";
      action = "<cmd>lua vim.lsp.buf.format()<cr>";
      options = {
        desc = "Format buffer";
      };
    }
    {
      mode = "n";
      key = "<C-c>";
      action = "\"+y";
      options = {
        desc = "Copy to system clipboard";
        silent = true;
      };
    }
    {
      mode = "v";
      key = "<C-c>";
      action = "\"+y";
      options = {
        desc = "Copy to system clipboard";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<C-v>";
      action = "<cmd>set paste<cr>\"+p<cmd>set nopaste<cr>";
      options = {
        desc = "Paste from system clipboard";
        silent = true;
      };
    }
    {
      mode = "i";
      key = "<C-v>";
      action = "<C-o><cmd>set paste<cr><C-r>+<C-o><cmd>set nopaste<cr>";
      options = {
        desc = "Paste from system clipboard";
        silent = true;
      };
    }
    {
      mode = "v";
      key = "<C-v>";
      action = "<cmd>set paste<cr>\"+p<cmd>set nopaste<cr>";
      options = {
        desc = "Paste from system clipboard";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<C-a>";
      action = "ggVG";
      options = {
        desc = "Select all";
        silent = true;
      };
    }

    # Window splits (your config)
    {
      mode = "n";
      key = "<leader>sv";
      action = "<C-w>v";
      options = {
        desc = "Split window vertically";
      };
    }
    {
      mode = "n";
      key = "<leader>sh";
      action = "<C-w>s";
      options = {
        desc = "Split window horizontally";
      };
    }
    {
      mode = "n";
      key = "<leader>se";
      action = "<C-w>=";
      options = {
        desc = "Make splits equal size";
      };
    }
    {
      mode = "n";
      key = "<leader>sx";
      action = "<cmd>close<CR>";
      options = {
        desc = "Close current split";
      };
    }

    # Buffer management (your config)
    {
      mode = "n";
      key = "<leader>bn";
      action = "<cmd>bn<CR>";
      options = {
        desc = "Next buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>bp";
      action = "<cmd>bp<CR>";
      options = {
        desc = "Previous buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>bD";
      action = "<cmd>bd!<cr>";
      options = {
        desc = "Force delete buffer";
        silent = true;
      };
    }

    # Window resizing
    {
      mode = "n";
      key = "<C-Up>";
      action = "<cmd>resize +2<cr>";
      options = {
        desc = "Increase Window Height";
      };
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = "<cmd>resize -2<cr>";
      options = {
        desc = "Decrease Window Height";
      };
    }
    {
      mode = "n";
      key = "<C-Left>";
      action = "<cmd>vertical resize -2<cr>";
      options = {
        desc = "Decrease Window Width";
      };
    }
    {
      mode = "n";
      key = "<C-Right>";
      action = "<cmd>vertical resize +2<cr>";
      options = {
        desc = "Increase Window Width";
      };
    }

    # Clear highlights
    {
      mode = "n";
      key = "<leader>ur";
      action = "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>";
      options = {
        desc = "Redraw / Clear hlsearch / Diff Update";
      };
    }

    # Better search navigation
    {
      mode = "n";
      key = "n";
      action = "'Nn'[v:searchforward].'zv'";
      options = {
        expr = true;
        desc = "Next Search Result";
      };
    }
    {
      mode = "x";
      key = "n";
      action = "'Nn'[v:searchforward]";
      options = {
        expr = true;
        desc = "Next Search Result";
      };
    }
    {
      mode = "o";
      key = "n";
      action = "'Nn'[v:searchforward]";
      options = {
        expr = true;
        desc = "Next Search Result";
      };
    }
    {
      mode = "n";
      key = "N";
      action = "'nN'[v:searchforward].'zv'";
      options = {
        expr = true;
        desc = "Prev Search Result";
      };
    }
    {
      mode = "x";
      key = "N";
      action = "'nN'[v:searchforward]";
      options = {
        expr = true;
        desc = "Prev Search Result";
      };
    }
    {
      mode = "o";
      key = "N";
      action = "'nN'[v:searchforward]";
      options = {
        expr = true;
        desc = "Prev Search Result";
      };
    }

    {
      mode = "n";
      key = "]d";
      action = "diagnostic_goto(true)";
      options = {
        desc = "Next Diagnostic";
      };
    }
    {
      mode = "n";
      key = "[d";
      action = "diagnostic_goto(false)";
      options = {
        desc = "Prev Diagnostic";
      };
    }
    {
      mode = "n";
      key = "]e";
      action = "diagnostic_goto(true 'ERROR')";
      options = {
        desc = "Next Error";
      };
    }
    {
      mode = "n";
      key = "[e";
      action = "diagnostic_goto(false 'ERROR')";
      options = {
        desc = "Prev Error";
      };
    }
    {
      mode = "n";
      key = "]w";
      action = "diagnostic_goto(true 'WARN')";
      options = {
        desc = "Next Warning";
      };
    }
    {
      mode = "n";
      key = "[w";
      action = "diagnostic_goto(false 'WARN')";
      options = {
        desc = "Prev Warning";
      };
    }

    # Terminal mode
    {
      mode = "t";
      key = "<esc><esc>";
      action = "<c-\\><c-n>";
      options = {
        desc = "Enter Normal Mode";
      };
    }
    {
      mode = "t";
      key = "<C-h>";
      action = "<cmd>wincmd h<cr>";
      options = {
        desc = "Go to Left Window";
      };
    }
    {
      mode = "t";
      key = "<C-j>";
      action = "<cmd>wincmd j<cr>";
      options = {
        desc = "Go to Lower Window";
      };
    }
    {
      mode = "t";
      key = "<C-k>";
      action = "<cmd>wincmd k<cr>";
      options = {
        desc = "Go to Upper Window";
      };
    }
    {
      mode = "t";
      key = "<C-l>";
      action = "<cmd>wincmd l<cr>";
      options = {
        desc = "Go to Right Window";
      };
    }
    {
      mode = "t";
      key = "<C-/>";
      action = "<cmd>close<cr>";
      options = {
        desc = "Hide Terminal";
      };
    }
  ];
}
