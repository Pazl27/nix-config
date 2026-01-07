{ pkgs, ... }:

{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "bento-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "serhez";
        repo = "bento.nvim";
        rev = "d5a2ede"; # or pin to a specific commit
        hash = "sha256-P8wWR/TMykbAjgWTTAq2KgYYVS+3wFjSmXlZSRlgwiA="; # nix will tell you the correct hash on first build
      };
    })
  ];

  extraConfigLua = ''
    require("bento").setup({
          main_keymap = ";", -- Main toggle/expand key
          lock_char = "🔒", -- Character shown before locked buffer names
          max_open_buffers = nil, -- Max buffers (nil = unlimited)
          buffer_deletion_metric = "frecency_access", -- Metric for buffer deletion (see below)
          buffer_notify_on_delete = true, -- Notify when deleting a buffer (false for silent deletion)
          ordering_metric = "access", -- Buffer ordering: nil (arbitrary), "access", or "edit"
          default_action = "open", -- Action when pressing label directly

          ui = {
              mode = "floating", -- "floating" | "tabline"
              floating = {
                  position = "middle-right", -- See position options below
                  offset_x = 0, -- Horizontal offset from position
                  offset_y = 0, -- Vertical offset from position
                  dash_char = "─", -- Character for collapsed dashes
                  label_padding = 1, -- Padding around labels
                  minimal_menu = nil, -- nil | "dashed" | "filename" | "full"
                  max_rendered_buffers = nil, -- nil (no limit) or number for pagination
              },
              tabline = {
                  left_page_symbol = "❮", -- Symbol shown when previous buffers exist
                  right_page_symbol = "❯", -- Symbol shown when more buffers exist
                  separator_symbol = "│", -- Separator between buffer components
              },
          },
    })
  '';
}
