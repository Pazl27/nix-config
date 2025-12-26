{ pkgs, ... }:
{
  plugins = {
    lsp-lines = {
      enable = true;
    };
    lsp-format = {
      enable = true;
    };
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
    lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        nixd = {
          enable = true;
          settings = {
            nixpkgs = {
              # Point to your nixpkgs input
              expr = "import <nixpkgs> { }";
            };
            formatting = {
              command = [ "nixfmt" ]; # or "alejandra" or "nixpkgs-fmt"
            };
            options = {
              # NixOS options
              nixos = {
                expr = ''(builtins.getFlake "/home/desktop/nix-config").nixosConfigurations.desktop.options'';
              };
              # Home Manager options
              home_manager = {
                expr = ''(builtins.getFlake "/home/desktop/nix-config").homeConfigurations.desktop.options'';
              };
            };
          };
        };
        html = {
          enable = true;
        };
        lua_ls = {
          enable = true;
        };
        ts_ls = {
          enable = true;
        };
        marksman = {
          enable = true;
        };
        clangd = {
          enable = true;
        };
        pyright = {
          enable = true;
        };
        # rust_analyzer is now handled by rustaceanvim, so it's removed
        gopls = {
          enable = true;
        };
        jsonls = {
          enable = true;
        };
        yamlls = {
          enable = true;
          extraOptions = {
            settings = {
              yaml = {
                schemas = {
                  kubernetes = "'*.yaml";
                  "http://json.schemastore.org/github-workflow" = ".github/workflows/*";
                  "http://json.schemastore.org/github-action" = ".github/action.{yml,yaml}";
                  "http://json.schemastore.org/ansible-stable-2.9" = "roles/tasks/*.{yml,yaml}";
                  "http://json.schemastore.org/kustomization" = "kustomization.{yml,yaml}";
                  "http://json.schemastore.org/ansible-playbook" = "*play*.{yml,yaml}";
                  "http://json.schemastore.org/chart" = "Chart.{yml,yaml}";
                  "https://json.schemastore.org/dependabot-v2" = ".github/dependabot.{yml,yaml}";
                  "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" =
                    "*docker-compose*.{yml,yaml}";
                  "https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json" =
                    "*flow*.{yml,yaml}";
                };
              };
            };
          };
        };
      };

      keymaps = {
        silent = true;
        lspBuf = {
          gd = {
            action = "definition";
            desc = "Goto Definition";
          };
          gr = {
            action = "references";
            desc = "Goto References";
          };
          gD = {
            action = "declaration";
            desc = "Goto Declaration";
          };
          gI = {
            action = "implementation";
            desc = "Goto Implementation";
          };
          gT = {
            action = "type_definition";
            desc = "Type Definition";
          };
          K = {
            action = "hover";
            desc = "Hover";
          };
          "<leader>cw" = {
            action = "workspace_symbol";
            desc = "Workspace Symbol";
          };
          "<leader>rn" = {
            action = "rename";
            desc = "Rename";
          };
        };
        diagnostic = {
          "<leader>xd" = {
            action = "open_float";
            desc = "Line Diagnostics";
          };
          "[d" = {
            action = "goto_next";
            desc = "Next Diagnostic";
          };
          "]d" = {
            action = "goto_prev";
            desc = "Previous Diagnostic";
          };
        };
      };
    };
  };

  extraPlugins = with pkgs.vimPlugins; [
    ansible-vim
  ];

  extraConfigLua = ''
    local _border = "rounded"

    -- Custom hover handler that shows both diagnostics and documentation
    vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
      config = config or {}
      config.border = _border

      local bufnr = ctx.bufnr
      local cursor_pos = vim.api.nvim_win_get_cursor(0)
      local row = cursor_pos[1] - 1  -- Convert to 0-indexed
      local col = cursor_pos[2]

      -- Get ALL diagnostics for current line (not just at cursor position)
      local line_diagnostics = vim.diagnostic.get(bufnr, { lnum = row })

      -- Also try to get diagnostics at the cursor position specifically
      local cursor_diagnostics = vim.diagnostic.get(bufnr, {
        lnum = row,
        col = col
      })

      -- Combine and deduplicate diagnostics
      local all_diagnostics = {}
      local seen = {}

      for _, diag in ipairs(line_diagnostics) do
        local key = diag.message .. diag.severity
        if not seen[key] then
          table.insert(all_diagnostics, diag)
          seen[key] = true
        end
      end

      for _, diag in ipairs(cursor_diagnostics) do
        local key = diag.message .. diag.severity
        if not seen[key] then
          table.insert(all_diagnostics, diag)
          seen[key] = true
        end
      end

      local contents = {}

      -- Add diagnostics first if they exist
      if #all_diagnostics > 0 then
        table.insert(contents, "**Diagnostics:**")
        table.insert(contents, "")

        for _, diagnostic in ipairs(all_diagnostics) do
          local severity = vim.diagnostic.severity[diagnostic.severity]
          local icon = ""
          if severity == "ERROR" then
            icon = " "
          elseif severity == "WARN" then
            icon = " "
          elseif severity == "INFO" then
            icon = " "
          elseif severity == "HINT" then
            icon = " "
          end

          table.insert(contents, icon .. "**" .. severity .. ":** " .. diagnostic.message)
          if diagnostic.source then
            table.insert(contents, "*Source: " .. diagnostic.source .. "*")
          end
          if diagnostic.code then
            table.insert(contents, "*Code: " .. diagnostic.code .. "*")
          end
        end

        -- Only add separator if we have both diagnostics and documentation
        if result and result.contents then
          table.insert(contents, "")
          table.insert(contents, "---")
          table.insert(contents, "")
        end
      end

      -- Add hover documentation if it exists
      if result and result.contents then
        if #all_diagnostics > 0 then
          table.insert(contents, "**Documentation:**")
          table.insert(contents, "")
        end

        local hover_contents = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
        for _, line in ipairs(hover_contents) do
          table.insert(contents, line)
        end
      end

      -- Show the combined contents
      if #contents > 0 then
        return vim.lsp.util.open_floating_preview(contents, "markdown", config)
      end

      -- If no diagnostics and no hover content, show just diagnostics if any exist on the line
      if #all_diagnostics > 0 then
        local diag_contents = { "**Diagnostics:**", "" }
        for _, diagnostic in ipairs(all_diagnostics) do
          local severity = vim.diagnostic.severity[diagnostic.severity]
          local icon = severity == "ERROR" and " " or
                      severity == "WARN" and " " or
                      severity == "INFO" and " " or " "
          table.insert(diag_contents, icon .. "**" .. severity .. ":** " .. diagnostic.message)
        end
        return vim.lsp.util.open_floating_preview(diag_contents, "markdown", config)
      end

      -- Fallback to default behavior if no content
      return vim.lsp.handlers.hover(_, result, ctx, config)
    end

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help, {
        border = _border
      }
    )

    -- Configure diagnostics for inline display (VSCode Error Lens style)
    vim.diagnostic.config({
      virtual_text = {
        enabled = true,
        source = "if_many",  -- Show source if multiple sources
        prefix = "●",        -- Icon before the diagnostic text
        spacing = 4,         -- Space between code and diagnostic
        format = function(diagnostic)
          -- Format: [ERROR] message (source)
          local severity = vim.diagnostic.severity[diagnostic.severity]
          return string.format("[%s] %s", severity, diagnostic.message)
        end,
      },
      float = { border = _border },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    require('lspconfig.ui.windows').default_options = {
      border = _border
    }

    -- Additional keymaps for <leader>xf (format)
    vim.keymap.set("n", "<leader>xf", function()
      vim.lsp.buf.format({ async = true })
    end, { desc = "Format Buffer", silent = true })

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
