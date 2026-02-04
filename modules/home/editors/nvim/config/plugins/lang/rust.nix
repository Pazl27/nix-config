{ pkgs, ... }:
{
  plugins = {
    rustaceanvim = {
      enable = true;
      # rustaceanvim handles rust-analyzer automatically
      settings = {
        server = {
          default_settings = {
            rust-analyzer = {
              check = {
                command = "clippy";
              };
              inlayHints = {
                enable = true;
              };
            };
          };
        };
      };
    };
  };
  extraConfigLua = ''
    -- Rust-specific keymaps that work with rustaceanvim
    -- These will only be active in Rust buffers
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "rust",
      callback = function(event)
        local bufnr = event.buf

        -- Override the global rename keymap for Rust files to use rustaceanvim
        vim.keymap.set("n", "<leader>rn", function()
          vim.cmd.RustLsp('rename')
        end, { buffer = bufnr, desc = "Rust Rename", silent = true })

        -- K for hover - use rustaceanvim's hover
        vim.keymap.set("n", "K", function()
          vim.cmd.RustLsp({ 'hover', 'actions' })
        end, { buffer = bufnr, desc = "Rust Hover Actions", silent = true })

        -- Code action with rustaceanvim
        vim.keymap.set("n", "<leader>ca", function()
          vim.cmd.RustLsp('codeAction')
        end, { buffer = bufnr, desc = "Rust Code Action", silent = true })

        -- Explain error (useful for Rust diagnostics)
        vim.keymap.set("n", "<leader>ce", function()
          vim.cmd.RustLsp('explainError')
        end, { buffer = bufnr, desc = "Explain Rust Error", silent = true })

        -- Open Cargo.toml
        vim.keymap.set("n", "<leader>rc", function()
          vim.cmd.RustLsp('openCargo')
        end, { buffer = bufnr, desc = "Open Cargo.toml", silent = true })
      end,
    })
  '';
}
