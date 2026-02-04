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
  };

  extraPlugins = with pkgs.vimPlugins; [
    go-nvim
    guihua-lua # Required by go.nvim
    neotest
    neotest-go
    nvim-nio # Required by neotest
    plenary-nvim # Required by neotest
    FixCursorHold-nvim # Required by neotest
  ];

  extraConfigLua = ''
    -- Setup go.nvim (minimal config for struct tags and iferr)
    require('go').setup({
      lsp_cfg = false,
      lsp_keymaps = false,
      diagnostic = { hdlr = false },
    })

    -- Configure neotest diagnostic display (recommended by neotest-go)
    local neotest_ns = vim.api.nvim_create_namespace("neotest")
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local message =
            diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          return message
        end,
      },
    }, neotest_ns)

    -- Helper function to find go.mod directory from a given path
    local function find_go_mod_root(path)
      local go_mod = vim.fn.findfile("go.mod", path .. ";")
      if go_mod ~= "" then
        return vim.fn.fnamemodify(go_mod, ":p:h")
      end
      return nil
    end

    -- Setup neotest with Go adapter
    -- Disable subprocess to work around nvim-nio compatibility issue
    require("neotest").setup({
      adapters = {
        require("neotest-go")({
          -- Custom root finder that looks for go.mod
          root_files = { "go.mod", "go.sum" },
          args = { "-v" },
        }),
      },
      -- Disable concurrent/async features that use subprocess
      discovery = {
        enabled = true,
        concurrent = 1,
      },
      running = {
        concurrent = false,
      },
      -- This is the key setting - disable subprocess for position parsing
      projects = {},
    })

    -- Monkey-patch to disable subprocess usage
    local lib = require("neotest.lib")
    if lib.subprocess and lib.subprocess.enabled then
      lib.subprocess.enabled = function() return false end
    end

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

        -- Run nearest test (with go.mod root detection)
        vim.keymap.set("n", "<leader>got", function()
          local current_file = vim.fn.expand("%:p:h")
          local go_root = find_go_mod_root(current_file)
          if go_root then
            require("neotest").run.run({ cwd = go_root })
          else
            require("neotest").run.run()
          end
        end, opts("Run nearest test"))

        -- Toggle test summary
        vim.keymap.set("n", "<leader>gos", function()
          require("neotest").summary.toggle()
        end, opts("Toggle test summary"))

        -- Run last test
        vim.keymap.set("n", "<leader>gol", function()
          local current_file = vim.fn.expand("%:p:h")
          local go_root = find_go_mod_root(current_file)
          if go_root then
            require("neotest").run.run_last({ cwd = go_root })
          else
            require("neotest").run.run_last()
          end
        end, opts("Run last test"))

        -- Show test output
        vim.keymap.set("n", "<leader>goo", function()
          require("neotest").output.open({ enter = true })
        end, opts("Show test output"))
      end,
    })

    -- Close neotest output with escape
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "neotest-output",
      callback = function(event)
        vim.keymap.set("n", "<Esc>", function()
          vim.api.nvim_win_close(0, true)
        end, { buffer = event.buf, silent = true })
      end,
    })
  '';
}
