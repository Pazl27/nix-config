{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.features.application.rofi = {
    enable = mkEnableOption "Rofi launcher with multiple themes";
  };

  config = mkIf config.features.application.rofi.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi;
      terminal = "${pkgs.kitty}/bin/kitty";
    };

    # ============================================
    # CONFIG 1: Main/Default
    # ============================================
    xdg.configFile."rofi/config.rasi".text = ''
      @theme "/dev/null"

      * {
        bg: #3c3836;
        background-color: @bg;
      }

      configuration {
        show-icons: true;
        icon-theme: "Adwaita";
        location: 0;
        font: "CaskaydiaCove Nerd Font 12";
        display-drun: "";
        
        /* for custom ones do Test:~/path/to/file */
        modi: "drun,window,ssh";
        display-drun: " ";
        display-window: "  ";
        display-ssh: "󱘖 ";
        kb-mode-complete: "";
        kb-element-next: "";
        kb-element-prev: "";
        kb-row-up: "Up,Control+k,";
        kb-row-down: "Down,Control+j";
        kb-accept-entry: "Control+m,Return,KP_Enter";
        terminal: "kitty";
        kb-remove-to-eol: "Control+Shift+e";
        kb-mode-next: "Tab,Shift+Right,Control+l";
        kb-mode-previous: "ISO_Left_Tab,Shift+Left,Control+h";
        kb-remove-char-back: "BackSpace";
      }

      window {
        width: 35%;
        transparency: "real";
        orientation: vertical;
        border-color: #a89984;
        border-radius: 15px;
      }

      mainbox {
        children: [inputbar, listview];
      }

      // ELEMENT
      // -----------------------------------
      element {
        padding: 4 12;
        text-color: #EFE7DD;
        border-radius: 10px;
      }

      element selected {
        background-color: #a89984;
      }

      element-text {
        background-color: inherit;
        text-color: inherit;
      }

      element-icon {
        size: 16 px;
        background-color: inherit;
        padding: 0 6 0 0;
        alignment: vertical;
      }

      listview {
        columns: 1;
        lines: 9;
        padding: 8 0;
        fixed-height: true;
        fixed-columns: true;
        fixed-lines: true;
      }

      // INPUT BAR
      //------------------------------------------------
      entry {
        text-color: #EFE7DD;
        padding: 10 10 0 0;
        margin: 0 -2 0 0;
      }

      inputbar {
        background-image: url("~/.config/rofi/girl-3.png", width);
        padding: 180 0 0;
        margin: 0 0 0 0;
      }

      prompt {
        text-color: #aaffaa;
        padding: 11 10 0 10;
        margin: 0 -2 0 0;
      }
    '';

    # ============================================
    # THEME: theme.rasi (shared theme)
    # ============================================
    xdg.configFile."rofi/theme.rasi".text = ''
      /*
       * ROFI color theme
       *
       * Based on https://github.com/Murzchnvok/rofi-collection Minimal theme
       *
       */
      configuration {
        font: "DepartureMono Nerd Font 14";
        drun {
          display-name: "";
        }
        run {
          display-name: "";
        }
        window {
          display-name: "";
        }
      }

      * {
        border: 0;
        margin: 0;
        padding: 0;
        spacing: 0;
        bg: rgb(43, 40, 38);
        bg-alt: #232323;
        fg: rgb(136, 128, 114);
        fg-alt: rgb(85, 80, 71);
        background-color: @bg;
        text-color: @fg;
      }

      window {
        transparency: "real";
        width: 700px;
        border-radius: 8px;
      }

      mainbox {
        children: [inputbar, listview];
      }

      inputbar {
        children: [prompt, entry];
      }

      entry {
        padding: 12px 0;
      }

      prompt {
        padding: 12px;
      }

      listview {
        lines: 8;
      }

      element {
        children: [element-icon, element-text];
      }

      element-icon {
        padding: 10px 10px;
      }

      element-text {
        padding: 12px 0;
        text-color: @fg-alt;
      }

      element-text selected {
        text-color: @fg;
      }
    '';

    # ============================================
    # CONFIG 2: AI
    # ============================================
    xdg.configFile."rofi/ai.rasi".text = ''
      @theme "theme.rasi"
    '';

    # ============================================
    # CONFIG 3: Wallpaper Select
    # ============================================
    xdg.configFile."rofi/wallselect.rasi".text = ''
      /*****----- Configuration -----*****/
      configuration {
          show-icons:                 true;
          drun-display-format:        "{name}";
        kb-mode-previous: "";
        kb-mode-next: "";
        kb-row-up: "Up,Control+k,";
        kb-row-down: "Down,Control+j";
        kb-row-left: "Control+h";
        kb-row-right: "Control+l";
      }

      /*****----- Global Properties -----*****/
      * {
          font:                        "JetBrains Mono Nerd Font 9";
          background:                  #1d2021;  /* Gruvbox dark bg */
          background-alt:              #3c3836;  /* Gruvbox dark alt bg */
          foreground:                  #ebdbb2;  /* Gruvbox fg */
          selected:                    #fB4934;  /* Gruvbox bright pink */
      }

      /*****----- Main Window -----*****/
      window {
          fullscreen:                  false;
          location:                    center;
          width:                       80%;
          border-radius:               6px;
          padding:                     10px;
          background-color:            transparent;
      }

      /*****----- Main Layout -----*****/
      mainbox {
          border-radius:               6px;
          spacing:                     0px;
          orientation:                 vertical;
          children:                    [ "inputbar", "listbox" ];
      }

      listbox {
          spacing:                     0px;
          orientation:                 vertical;
          children:                    [ "listview" ];
      }

      /*****----- Input Bar (Search) -----*****/
      inputbar {
          children: [prompt, entry];
          background-color:            #3c3836;  /* Gruvbox dark bg */
      }

      prompt {
          padding:                     10px;
          text-color:                  #ebdbb2;  
          background-color:            #3c3836;  /* Gruvbox dark bg */
      }

      entry {
          padding:                     10px 0;
          text-color:                  #ebdbb2;
          background-color:            #3c3836;  /* slightly darker for input */
          border-radius:               4px;
      }

      /*****----- Listview: Icon Grid -----*****/
      listview {
          columns:                     5;
          lines:                       3;
          layout:                      vertical;
          fixed-columns:               true;
          fixed-height:                true;
          dynamic:                     false;
          spacing:                     10px;
          padding:                     8px;
          border-radius:               0px 0px 6px 6px;
          background-color:            #282828;  /* Gruvbox slightly lighter bg for grid */
      }

      /*****----- Element Styling -----*****/
      element {
          padding:                     0px 10px 0px 10px;
          border-radius:               6px;
          background-color:            transparent;
          horizontal-align:            0.5;
      }

      element selected.normal {
          background-color:            @selected;
      }

      element-icon {
          size:                        159px;
          border-radius:               6px;
          background-color:            transparent;
          vertical-align:              0.5;
          padding:                     2px;
      }

      element-text {
          text-color:                  transparent;
          background-color:            transparent;
          padding:                     0px;
          font:                        "JetBrains Mono Nerd Font 0";
      }
    '';

  };
}

