{ pkgs, ... }:

{
  extraPackages = with pkgs; [
    imagemagick
    ghostscript
  ];

  plugins.image = {
    enable = true;

    settings = {
      backend = "kitty";
      processor = "magick_cli";

      integrations = {
        markdown = {
          enabled = true;
          download_remote_images = true;
          only_render_image_at_cursor = true;
          only_render_image_at_cursor_mode = "inline";
          filetypes = [
            "markdown"
            "vimwiki"
            "leetcode.nvim"
          ];
        };
      };

      window_overlap_clear_enabled = true;
      editor_only_render_when_focused = false;
      tmux_show_only_in_active_window = true;
    };
  };
}
