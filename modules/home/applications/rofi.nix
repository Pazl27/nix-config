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

    xdg.configFile."rofi/list.rasi".text = ''
            /*****----- Configuration -----*****/
            configuration {
                  show-icons:                 false;
                    display-columns:            1;
                    kb-mode-previous:           "";
                    kb-mode-next:               "";
                    kb-row-up:                  "Up,Control+k";
                    kb-row-down:                "Down,Control+j";
                    kb-accept-entry:            "Control+m,Return,KP_Enter";
                }

            /*****----- Global Properties -----*****/
            * {
                  font:                        "JetBrains Mono Nerd Font 11";
                    background:                  #1d2021;
                    background-alt:              #282828;
                    foreground:                  #ebdbb2;
                    selected:                    #504945;
                    active:                      #FE8019;
                    urgent:                      #fb4934;
                    border-color:                #3c3836;
                    input-bg:                    #3c3836;
                }

            /*****----- Main Window -----*****/
            window {
                  transparency:                "real";
                    location:                    center;
                    anchor:                      center;
                    fullscreen:                  false;
                    width:                       650px;
                    border-radius:               12px;
                    border:                      1px;  /* Smaller border */
                    border-color:                @border-color;
                    background-color:            @background;
                    padding:                     15px;  /* More space */
                }

            /*****----- Main Box -----*****/
            mainbox {
                  enabled:                     true;
                    spacing:                     15px;  /* More spacing between sections */
              margin:                      0px;
                padding:                     0px;
                background-color:            transparent;
                children:                    [ "inputbar", "message", "listview" ];
            }

          /*****----- Input Bar -----*****/
          inputbar {
                enabled:                     true;
                  spacing:                     12px;
            margin:                      0px;
              padding:                     12px 18px;  /* More padding */
              border:                      0px;  /* No border */
              border-radius:               10px;  /* Rounded like selected items */
              background-color:            @input-bg;  /* Floating appearance */
              text-color:                  @foreground;
              children:                    [ "prompt", "entry" ];
          }

      prompt {
            enabled:                     true;
              background-color:            transparent;
              text-color:                  @active;
          }

      entry {
            enabled:                     true;
              background-color:            transparent;
              text-color:                  @foreground;
              cursor:                      text;
              placeholder:                 "Search...";
              placeholder-color:           #928374;
          }

      /*****----- Message -----*****/
      message {
            enabled:                     true;
              margin:                      0px;
              padding:                     12px;
              border:                      0px;
              border-radius:               10px;
              background-color:            @background-alt;
              text-color:                  @foreground;
          }

      textbox {
            background-color:            transparent;
              text-color:                  @foreground;
              vertical-align:              0.5;
              horizontal-align:            0.0;
          }

      /*****----- Listview -----*****/
      listview {
            enabled:                     true;
              columns:                     1;
              lines:                       8;
              cycle:                       true;
              dynamic:                     true;
              scrollbar:                   false;
              layout:                      vertical;
              reverse:                     false;
              fixed-height:                true;
              fixed-columns:               true;
              spacing:                     8px;  /* More space between items */
              margin:                      0px;
              padding:                     5px 0px;  /* Vertical padding */
              background-color:            transparent;
              border:                      0px;
          }

      /*****----- Elements -----*****/
      element {
            enabled:                     true;
              spacing:                     12px;
              margin:                      0px;
              padding:                     12px 18px;  /* More padding */
              border:                      0px;
              border-radius:               10px;  /* Rounded like input */
              background-color:            transparent;
              text-color:                  @foreground;
              cursor:                      pointer;
          }

      element normal.normal {
            background-color:            transparent;
              text-color:                  @foreground;
          }

      element selected.normal {
            background-color:            @selected;  /* Same as input bg style */
              text-color:                  @foreground;
          }

      element alternate.normal {
            background-color:            transparent;
              text-color:                  @foreground;
          }

      element-text {
            background-color:            transparent;
              text-color:                  inherit;
            cursor:                      inherit;
            vertical-align:              0.5;
            horizontal-align:            0.0;
          }

      element-icon {
            background-color:            transparent;
              size:                        18px;
              cursor:                      inherit;
        }
    '';

    xdg.configFile."rofi/wallpaper.rasi".text = ''
      /* config - Wallpaper select */

      configuration {
          modi:                        "drun";
          show-icons:                  true;
        	drun-display-format:         "{name}";
          hover-select:                true;
          font:                        "JetBrains Mono Nerd Font 10";

          kb-mode-previous: "";
          kb-mode-next: "";
          kb-row-up: "Up,Control+k,";
          kb-row-down: "Down,Control+j";
          kb-row-left: "Control+h";
          kb-row-right: "Control+l";
      }

      /* Config and colors ----------------------------------------------- */

      * {
            background:                  #282828FF;
            background-alt:              #3c3836FF;
            foreground:                  #EBDBB2FF;
            selected:                    #83A598FF;
            active:                      #B8BB26FF;
            urgent:                      #FB4934FF;

            text-selected:               #282828FF;
            text:                        #EBDBB2FF;

            shade-shadow:                white / 6%;
            shade-bg:                    white / 12%;
            shade-border:                white / 24%;
      }

      window {
            fullscreen:                  true;
            transparency:                "real";
            cursor:                      "default";
            background-color:            black / 12%;
            border:                      0px;
            border-color:                @selected;
            width:                       100%;
            height:                      100%;
            margin:                      0px;
            padding:                     0px;
      }

      /* Elements ----------------------------------------------------- */
      element normal.normal, element alternate.normal {
            background-color:            transparent;
            text-color:                  @text;
      }

      element selected.normal {
            background-color:            @shade-bg;
            text-color:                  white;
            border:                      1px solid;
            border-color:                @selected;
      }

      element-text {
            background-color:            transparent;
            text-color:                  inherit;
            highlight:                   inherit;
            cursor:                      inherit;
            vertical-align:              0.5;
            horizontal-align:            0.5;
      }

      /* Listview ---------------------------------------------------- */

      listview {
          border:                        0px;
      }

      /* Scrollbar ---------------------------------------------------- */
      scrollbar {
            margin:                      0px 4px;
            handle-width:                8px;
            handle-color:                white;
            background-color:            @shade-shadow;
            border-radius:               4px;
      }

      /* Message ------------------------------------------------------ */
      message {
            background-color:            @shade-bg;
            border:                      1px solid;
            border-color:                transparent;
            border-radius:               12px;
            padding:                     24px;
      }

      error-message {
            padding:                     100px;
            border:                      0px solid;
            border-radius:               0px;
            background-color:            black / 10%;
            text-color:                  @text;
      }

      textbox {
            background-color:            transparent;
            text-color:                  @text;
            vertical-align:              0.5;
            horizontal-align:            0.5;
            highlight:                   none;
      }

      /* Main Box --------------------------------------------------- */
      mainbox {
          children:                    [ "inputbar", "listview" ];
          background-color:            transparent;

          spacing:                     24px;
          margin:                      0px;
          padding:                     64px;
      }

      /* ---- List ---- */
      listview {
          columns:                     4;
          lines:                       4;
          cycle:                       true;
          dynamic:                     true;
          scrollbar:                   false;
          layout:                      vertical;
          reverse:                     false;
          fixed-height:                true;
          fixed-columns:               true;

          background-color:           transparent;
          text-color:                 @foreground;

          spacing:                     0px;
          margin:                      0px;
          padding:                     0px;
      }

      /* Elements --------------------------------------------------- */
      element {
          cursor:                      pointer;
          border-radius:               36px;
          background-color:            transparent;
          text-color:                  @foreground;
          orientation:                 vertical;

          spacing:                     0px;
          margin:                      0px;
          padding:                     0px;
      }

      element-icon {
          expand:                      false;
          background-color:            transparent;
          text-color:                  inherit;
          size:                        26%;
          cursor:                      inherit;
      }

        /* Search Bar -------------------------------------------------- */
      inputbar {
            children: [ "textbox-prompt", "entry" ];
            background-color: transparent;
            text-color: @foreground;
            spacing: 16px;
            padding: 0px 64px;
      }

        textbox-prompt {
            expand: false;
            background-color: transparent;
            text-color: @foreground;
            text: "Search:";
            font: "JetBrains Mono Nerd Font 10";
            horizontal-align: 0.0;
      }

        entry {
            background-color: @shade-bg;
            text-color: @text;
            border-radius: 12px;
            padding: 8px 16px;
            placeholder: "Type to search…";
            highlight: @selected;
      }
    '';

    home.file.".config/rofi" = {
      source = ../../../assets/rofi;
      recursive = true;
    };

  };
}
