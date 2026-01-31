_: {
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        globalstatus = true;
        extensions = [
          "fzf"
          "neo-tree"
        ];
        disabledFiletypes = {
          statusline = [
            "startup"
            "alpha"
          ];
        };
        theme = {
          normal = {
            a = {
              bg = "#98971a"; # gruvbox green
              fg = "#282828"; # gruvbox bg0_h (darker)
              gui = "bold";
            };
            b = {
              bg = "#3c3836"; # gruvbox bg1
              fg = "#ebdbb2"; # gruvbox fg1
            };
            c = {
              bg = "#282828"; # gruvbox bg0_h
              fg = "#a89984"; # gruvbox fg4 (dimmer)
            };
          };
          insert = {
            a = {
              bg = "#458588"; # gruvbox blue
              fg = "#282828";
              gui = "bold";
            };
            b = {
              bg = "#3c3836";
              fg = "#ebdbb2";
            };
            c = {
              bg = "#282828";
              fg = "#a89984";
            };
          };
          visual = {
            a = {
              bg = "#d3869b"; # gruvbox purple (lighter)
              fg = "#282828";
              gui = "bold";
            };
            b = {
              bg = "#3c3836";
              fg = "#ebdbb2";
            };
            c = {
              bg = "#282828";
              fg = "#a89984";
            };
          };
          command = {
            a = {
              bg = "#b16286"; # gruvbox purple
              fg = "#282828";
              gui = "bold";
            };
            b = {
              bg = "#3c3836";
              fg = "#ebdbb2";
            };
            c = {
              bg = "#282828";
              fg = "#a89984";
            };
          };
          replace = {
            a = {
              bg = "#d79921"; # gruvbox yellow
              fg = "#282828";
              gui = "bold";
            };
            b = {
              bg = "#3c3836";
              fg = "#ebdbb2";
            };
            c = {
              bg = "#282828";
              fg = "#a89984";
            };
          };
          inactive = {
            a = {
              bg = "#3c3836"; # gruvbox bg1
              fg = "#7c6f64"; # gruvbox gray (dimmer)
              gui = "bold";
            };
            b = {
              bg = "#282828";
              fg = "#7c6f64";
            };
            c = {
              bg = "#282828";
              fg = "#665c54"; # gruvbox bg4 (even dimmer)
            };
          };
        };
      };
      sections = {
        lualine_a = [
          {
            __unkeyed-1 = "mode";
            icon = "";
          }
        ];
        lualine_b = [
          {
            __unkeyed-1 = "branch";
            icon = "";
          }
          {
            __unkeyed-1 = "diff";
            symbols = {
              added = " ";
              modified = " ";
              removed = " ";
            };
          }
        ];
        lualine_c = [
          {
            __unkeyed-1 = "diagnostics";
            sources = [ "nvim_lsp" ];
            symbols = {
              error = " ";
              warn = " ";
              info = " ";
              hint = "󰝶 ";
            };
          }
          # {
          #   __unkeyed-1 = "navic";
          # }
          # Rust: Cargo project info
          {
            __unkeyed-1.__raw = ''
              function()
                if vim.bo.filetype ~= "rust" then
                  return ""
                end
                
                local cwd = vim.fn.getcwd()
                local cargo_toml = cwd .. "/Cargo.toml"
                
                if vim.fn.filereadable(cargo_toml) == 0 then
                  return ""
                end
                
                -- Read Cargo.toml and extract package name
                local lines = vim.fn.readfile(cargo_toml)
                local package_name = ""
                local version = ""
                
                for _, line in ipairs(lines) do
                  local name_match = line:match('^name%s*=%s*"(.+)"')
                  if name_match then
                    package_name = name_match
                  end
                  local ver_match = line:match('^version%s*=%s*"(.+)"')
                  if ver_match then
                    version = ver_match
                  end
                end
                
                if package_name ~= "" then
                  return " " .. package_name .. (version ~= "" and " v" .. version or "")
                end
                
                return ""
              end
            '';
            color = {
              fg = "#fe8019";
            }; # gruvbox orange
          }
        ];
        lualine_x = [
          # Rust: Analyzer status
          {
            __unkeyed-1.__raw = ''
              function()
                if vim.bo.filetype ~= "rust" then
                  return ""
                end
                
                local clients = vim.lsp.get_clients({ bufnr = 0, name = "rust_analyzer" })
                if #clients == 0 then
                  return ""
                end
                
                -- Check if rust-analyzer is ready
                local client = clients[1]
                if client and client.server_capabilities then
                  return "󱘗 rust-analyzer"
                end
                
                return "󱘗 loading..."
              end
            '';
            color = {
              fg = "#d65d0e";
            }; # gruvbox orange (darker)
            cond.__raw = ''
              function()
                return vim.bo.filetype == "rust"
              end
            '';
          }
          # Rust: Build mode (debug/release)
          {
            __unkeyed-1.__raw = ''
              function()
                if vim.bo.filetype ~= "rust" then
                  return ""
                end
                
                -- Check for CARGO_BUILD_TARGET or default to debug
                local mode = vim.env.CARGO_BUILD_TARGET or "debug"
                local icon = mode == "release" and "󰗀" or "󰙨"
                
                return icon .. " " .. mode
              end
            '';
            color.__raw = ''
              function()
                local mode = vim.env.CARGO_BUILD_TARGET or "debug"
                if mode == "release" then
                  return { fg = "#b8bb26" }  -- gruvbox green
                else
                  return { fg = "#fabd2f" }  -- gruvbox yellow
                end
              end
            '';
            cond.__raw = ''
              function()
                return vim.bo.filetype == "rust"
              end
            '';
          }
          {
            __unkeyed-1 = "filetype";
            icon_only = true;
            separator = "";
            padding = {
              left = 1;
              right = 0;
            };
          }
          {
            __unkeyed-1 = "filename";
            path = 1;
          }
          {
            __unkeyed-1.__raw = ''
              function()
                local icon = " "
                local status = require("copilot.api").status.data
                return icon .. (status.message or " ")
              end
            '';
            cond.__raw = ''
              function()
               local ok, clients = pcall(vim.lsp.get_clients, { name = "copilot", bufnr = 0 })
               return ok and #clients > 0
              end
            '';
          }
        ];
        lualine_y = [
          {
            __unkeyed-1 = "progress";
          }
        ];
        lualine_z = [
          {
            __unkeyed-1 = "location";
          }
        ];
      };
    };
  };
}
