{ pkgs, ... }:

{
  # Go tooling packages
  extraPackages = with pkgs; [
    # Formatter - stricter than gofmt, sorts imports
    goimports-reviser
    # Go tools
    gomodifytags # For struct tag generation
    iferr # For error handling boilerplate
  ];

  plugins = {
    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          go = [ "goimports-reviser" ];
        };
        formatters = {
          goimports-reviser = {
            command = "${pkgs.goimports-reviser}/bin/goimports-reviser";
            args = [
              "-rm-unused"
              "-set-alias"
              "-format"
              "$FILENAME"
            ];
            stdin = false;
          };
        };
        format_on_save = {
          timeout_ms = 3000;
          lsp_fallback = true;
        };
      };
    };

    # Neotest for running tests
    neotest = {
      enable = true;
      adapters = {
        go = {
          enable = true;
          settings = {
            experimental = {
              test_table = true;
            };
            args = [ "-v" ];
          };
        };
      };
    };
  };

  extraPlugins = with pkgs.vimPlugins; [
    go-nvim
    guihua-lua # Required by go.nvim
  ];

  extraConfigLua = ''
    -- Setup go.nvim (minimal config for struct tags and iferr)
    require('go').setup({
      lsp_cfg = false,
      lsp_keymaps = false,
      diagnostic = { hdlr = false },
    })

    -- Go-specific keymaps
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "go",
      callback = function(event)
        local bufnr = event.buf
        local opts = function(desc)
          return { buffer = bufnr, desc = desc, silent = true }
        end

        -- Add JSON struct tags
        vim.keymap.set("n", "<leader>goj", "<cmd>GoAddTag json<cr>", opts("Add JSON tags"))
        vim.keymap.set("n", "<leader>goJ", "<cmd>GoRmTag json<cr>", opts("Remove JSON tags"))

        -- Generate if err
        vim.keymap.set("n", "<leader>goe", "<cmd>GoIfErr<cr>", opts("Generate if err"))

        -- Run nearest test
        vim.keymap.set("n", "<leader>got", function()
          require("neotest").run.run()
        end, opts("Run nearest test"))

        -- Run last test
        vim.keymap.set("n", "<leader>gol", function()
          require("neotest").run.run_last()
        end, opts("Run last test"))

        -- Show test output
        vim.keymap.set("n", "<leader>goo", function()
          require("neotest").output.open({ enter = true })
        end, opts("Show test output"))
      end,
    })
  '';
}
