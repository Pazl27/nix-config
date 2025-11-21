{
  plugins.alpha = {
    enable = true;

    settings.layout = [
      {
        type = "text";
        val = [
          "=================     ===============     ===============   ========  ========"
          "\\\\ . . . . . . .\\\\   //. . . . . . .\\\\   //. . . . . . .\\\\  \\\\. . .\\\\// . . //"
          "||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\\/ . . .||"
          "|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||"
          "||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||"
          "|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\\ . . . . ||"
          "||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\\_ . .|. .||"
          "|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\\ `-_/| . ||"
          "||_-' ||  .|/    || ||    \\|.  || `-_|| ||_-' ||  .|/    || ||   | \\  / |-_.||"
          "||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \\  / |  `||"
          "||    `'         || ||         `'    || ||    `'         || ||   | \\  / |   ||"
          "||            .===' `===.         .==='.`===.         .===' /==. |  \\/  |   ||"
          "||         .=='   \\_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \\/  |   ||"
          "||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \\/  |   ||"
          "||   .=='    _-'          '-__\\._-'         '-_./__-'         `' |. /|  |   ||"
          "||.=='    _-'                                                     `' |  /==.||"
          "=='    _-'                        N E O V I M                         \\/   `=="
          "\\   _-'                                                                `-_   /"
          " `''                                                                      ``' "
        ];
        opts = {
          position = "center";
          hl = "AlphaHeader";
        };
      }
      {
        type = "padding";
        val = 2;
      }
      {
        type = "group";
        val = [
          {
            type = "text";
            val = "Quick links";
            opts = {
              hl = "SpecialComment";
              position = "center";
            };
          }
          {
            type = "padding";
            val = 0;
          }
          {
            type = "button";
            val = " New file";
            on_press.__raw = "function() vim.cmd[[ene | startinsert]] end";
            opts = {
              shortcut = "n";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "Keyword";
            };
          }
          {
            type = "button";
            val = "󰈞 Find file";
            on_press.__raw = "function() vim.cmd[[Telescope find_files]] end";
            opts = {
              shortcut = "f";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "Keyword";
            };
          }
          {
            type = "button";
            val = "󰊄 Live grep";
            on_press.__raw = "function() vim.cmd[[Telescope live_grep]] end";
            opts = {
              shortcut = "g";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "Keyword";
            };
          }
          {
            type = "button";
            val = " Recent files";
            on_press.__raw = "function() vim.cmd[[Telescope oldfiles]] end";
            opts = {
              shortcut = "r";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "Keyword";
            };
          }
          {
            type = "button";
            val = " Configuration";
            on_press.__raw = "function() vim.cmd[[cd ~/home-manager | edit ~/home-manager/modules/editors/nvim/default.nix]] end";
            opts = {
              shortcut = "c";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "Keyword";
            };
          }
          {
            type = "button";
            val = " Quit";
            on_press.__raw = "function() vim.cmd[[qa]] end";
            opts = {
              shortcut = "q";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "Keyword";
            };
          }
        ];
      }
      {
        type = "padding";
        val = 2;
      }
    ];

    settings.opts = {
      margin = 5;
      setup.__raw = ''
        function()
          vim.api.nvim_create_autocmd('DirChanged', {
            pattern = '*',
            group = vim.api.nvim_create_augroup("alpha_temp", { clear = true }),
            callback = function()
              require('alpha').redraw()
            end,
          })
        end
      '';
    };
  };

  # Custom highlight and additional configuration
  extraConfigLua = ''
    -- Define custom highlight group for Alpha header
    vim.cmd("hi AlphaHeader guifg=#FB4934 guibg=NONE gui=NONE")

    -- Custom MRU function (simplified version)
    local function setup_alpha_mru()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Get recent files
      local function get_recent_files(max_files)
        max_files = max_files or 8
        local files = {}

        for _, file in pairs(vim.v.oldfiles) do
          if #files >= max_files then break end

          if vim.fn.filereadable(file) == 1 and
             not string.find(file, "COMMIT_EDITMSG") and
             not vim.startswith(file, "/tmp/") then

            local short_name = vim.fn.fnamemodify(file, ":t")
            local dir_name = vim.fn.fnamemodify(file, ":h:t")

            if #short_name > 30 then
              short_name = string.sub(short_name, 1, 27) .. "..."
            end

            table.insert(files, {
              name = short_name .. " (" .. dir_name .. ")",
              path = file,
              shortcut = tostring(#files + 1)
            })
          end
        end

        return files
      end

      -- Create MRU section
      local function create_mru_section()
        local files = get_recent_files(8)
        local mru_buttons = {}

        -- Add header
        table.insert(mru_buttons, {
          type = "text",
          val = "Recent files",
          opts = {
            hl = "SpecialComment",
            position = "center",
          }
        })

        table.insert(mru_buttons, { type = "padding", val = 1 })

        -- Add file buttons
        for _, file in ipairs(files) do
          table.insert(mru_buttons, {
            type = "button",
            val = " " .. file.name,
            on_press = function()
              vim.cmd("edit " .. vim.fn.fnameescape(file.path))
            end,
            opts = {
              shortcut = file.shortcut,
              position = "center",
              cursor = 3,
              width = 50,
              align_shortcut = "right",
              hl_shortcut = "Number",
            }
          })
        end

        return mru_buttons
      end

      -- Update layout with MRU
      local config = alpha.default_config
      if config and config.layout then
        -- Add MRU section before the last padding
        table.insert(config.layout, #config.layout, {
          type = "group",
          val = create_mru_section()
        })
        table.insert(config.layout, { type = "padding", val = 1 })

        alpha.setup(config)
      end
    end

    -- Setup MRU after alpha loads
    vim.defer_fn(setup_alpha_mru, 100)
  '';
}
