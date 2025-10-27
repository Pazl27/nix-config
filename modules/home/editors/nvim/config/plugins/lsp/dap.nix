{ pkgs, ... }:
let
  # Get codelldb extension path
  codelldb = pkgs.vscode-extensions.vadimcn.vscode-lldb;
in
{
  plugins = {
    # DAP core
    dap = {
      enable = true;

      # DAP signs/icons
      signs = {
        dapBreakpoint = {
          text = "";
          texthl = "DapBreakpoint";
        };
        dapBreakpointCondition = {
          text = "";
          texthl = "DapBreakpoint";
        };
        dapBreakpointRejected = {
          text = "";
          texthl = "DapBreakpoint";
        };
        dapLogPoint = {
          text = "";
          texthl = "DapLogPoint";
        };
        dapStopped = {
          text = "";
          texthl = "DapStopped";
          linehl = "DapStoppedLine"; # Highlight the entire line
        };
      };

    };
    # Extensions
    dap-ui = {
      enable = true;
    };

    dap-virtual-text = {
      enable = true;
    };

    dressing= {
      enable = true;
    };
  };

  # Install debuggers
  extraPackages = with pkgs; [
    vscode-extensions.vadimcn.vscode-lldb # CodeLLDB
  ];

  extraConfigLua = ''
    local dap = require('dap')
    local dapui = require('dapui')
    local widgets = require('dap.ui.widgets')

    -- Set up highlighting for the current line during debugging
    vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#fb4934' })  -- Red for breakpoints
    vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef' })
    vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#98c379' })  -- Green arrow
    vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#3e4451' })  -- Highlight entire current line

    -- Configure DAP UI with bottom layout
    dapui.setup({
      layouts = {
        {
          elements = {
            { id = "console", size = 1.0 },
          },
          size = 40, -- Width of the left sidebar
          position = "left",
        },
        {
          elements = {
            { id = "scopes", size = 0.7 },
            { id = "repl", size = 0.3 },
          },
          size = 20, -- Height of the bottom bar
          position = "bottom",
        },
      },
      controls = {
        enabled = true,
        element = "repl",
      },
      floating = {
        border = "rounded",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
    })

    -- CodeLLDB adapter
    dap.adapters.codelldb = {
      type = 'server',
      port = "''${port}",
      executable = {
        command = '${codelldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb',
        args = {"--port", "''${port}"},
      }
    }

    -- Rust configuration using CodeLLDB
    dap.configurations.rust = {
      {
        name = 'Launch',
        type = 'codelldb',
        request = 'launch',
        program = function()
          local cwd = vim.fn.getcwd()
          local cargo_metadata = vim.fn.system('cargo metadata --format-version 1 --no-deps')
          local metadata = vim.fn.json_decode(cargo_metadata)

          if metadata and metadata.packages and #metadata.packages > 0 then
            local package = metadata.packages[1]
            local target_dir = metadata.target_directory

            for _, target in ipairs(package.targets) do
              if vim.tbl_contains(target.kind, 'bin') then
                local binary_path = target_dir .. '/debug/' .. target.name
                if vim.fn.filereadable(binary_path) == 1 then
                  return binary_path
                end
              end
            end
          end

          return vim.fn.input('Path to executable: ', cwd .. '/target/debug/', 'file')
        end,
        cwd = vim.fn.getcwd(),
        stopOnEntry = false,
        args = {},
        console = "integratedTerminal",
      },
      {
        name = 'Launch (with args)',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
        end,
        cwd = vim.fn.getcwd(),
        stopOnEntry = false,
        args = function()
          local args_string = vim.fn.input('Arguments: ')
          return vim.split(args_string, " ")
        end,
        console = "integratedTerminal",
      },
      {
        name = 'Attach to process',
        type = 'codelldb',
        request = 'attach',
        pid = require('dap.utils').pick_process,
      },
    }

    -- Automatically open/close DAP UI
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Keymaps for debugging
    vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Debug: Continue/Start' })
    vim.keymap.set('n', '<leader>ds', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<leader>do', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>dB', function()
      dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
    end, { desc = 'Debug: Set Conditional Breakpoint' })
    vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'Debug: Open REPL' })
    vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = 'Debug: Run Last' })
    vim.keymap.set('n', '<leader>dt', dapui.toggle, { desc = 'Debug: Toggle UI' })
    vim.keymap.set('n', '<leader>dx', dap.terminate, { desc = 'Debug: Terminate' })

    -- DAP UI widgets
    vim.keymap.set({'n', 'v'}, '<leader>dh', widgets.hover, { desc = 'Debug: Hover' })
    vim.keymap.set({'n', 'v'}, '<leader>dp', widgets.preview, { desc = 'Debug: Preview' })
    vim.keymap.set('n', '<leader>df', function() widgets.centered_float(widgets.frames) end, { desc = 'Debug: Frames' })
    vim.keymap.set('n', '<leader>dw', function() widgets.centered_float(widgets.watches) end, { desc = 'Debug: Watches' })
    vim.keymap.set('n', '<leader>de', function()
      widgets.centered_float(widgets.expression)
    end, { desc = 'Debug: Evaluate Expression' })
  '';
}
