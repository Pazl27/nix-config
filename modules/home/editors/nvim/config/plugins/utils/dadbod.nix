_: {
  plugins.vim-dadbod.enable = true;

  plugins.vim-dadbod-ui = {
    enable = true;
    settings = {
      db_ui_save_location = "~/.local/share/db_ui";
      db_ui_use_nerd_fonts = 1;
      db_ui_auto_execute_table_helpers = 1;
    };
  };

  plugins.vim-dadbod-completion.enable = true;
}
