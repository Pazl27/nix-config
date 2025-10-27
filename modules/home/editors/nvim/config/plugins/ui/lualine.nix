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
              bg = "#98971a";  # gruvbox green
              fg = "#282828";  # gruvbox bg0_h (darker)
              gui = "bold";
            };
            b = {
              bg = "#3c3836";  # gruvbox bg1
              fg = "#ebdbb2";  # gruvbox fg1
            };
            c = {
              bg = "#282828";  # gruvbox bg0_h
              fg = "#a89984";  # gruvbox fg4 (dimmer)
            };
          };
          insert = {
            a = {
              bg = "#458588";  # gruvbox blue
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
              bg = "#d3869b";  # gruvbox purple (lighter)
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
              bg = "#b16286";  # gruvbox purple
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
              bg = "#d79921";  # gruvbox yellow
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
              bg = "#3c3836";  # gruvbox bg1
              fg = "#7c6f64";  # gruvbox gray (dimmer)
              gui = "bold";
            };
            b = {
              bg = "#282828";
              fg = "#7c6f64";
            };
            c = {
              bg = "#282828";
              fg = "#665c54";  # gruvbox bg4 (even dimmer)
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
            icon = "";
          }
          {
            __unkeyed-1 = "diff";
            symbols = {
              added = " ";
              modified = " ";
              removed = " ";
            };
          }
        ];
        lualine_c = [
          {
            __unkeyed-1 = "diagnostics";
            sources = [ "nvim_lsp" ];
            symbols = {
              error = " ";
              warn = " ";
              info = " ";
              hint = "󰝶 ";
            };
          }
          {
            __unkeyed-1 = "navic";
          }
        ];
        lualine_x = [
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
                local icon = " "
                local status = require("copilot.api").status.data
                return icon .. (status.message or " ")
              end,

              cond = function()
               local ok, clients = pcall(vim.lsp.get_clients, { name = "copilot", bufnr = 0 })
               return ok and #clients > 0
              end,
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
