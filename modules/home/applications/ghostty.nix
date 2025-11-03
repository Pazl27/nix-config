{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.features.application.ghostty = {
    enable = mkEnableOption "Ghostty terminal with Gruvbox theme";
  };

  config = mkIf config.features.application.ghostty.enable {
    # Ghostty package
    home.packages = with pkgs; [
      ghostty
    ];

    # Ghostty configuration
    xdg.configFile."ghostty/config".text = ''
      # ============================================
      # THEME - GRUVBOX DARK HARD
      # ============================================
      
      # Background & Foreground
      background = #1d2021
      foreground = #ebdbb2
      
      # Cursor
      cursor-color = #ebdbb2
      cursor-text = #1d2021
      
      # Selection
      selection-background = #ebdbb2
      selection-foreground = #1d2021
      
      # Black
      palette = 0=#1d2021
      palette = 8=#928374
      
      # Red
      palette = 1=#cc241d
      palette = 9=#fb4934
      
      # Green
      palette = 2=#98971a
      palette = 10=#b8bb26
      
      # Yellow
      palette = 3=#d79921
      palette = 11=#fabd2f
      
      # Blue
      palette = 4=#458588
      palette = 12=#83a598
      
      # Magenta
      palette = 5=#b16286
      palette = 13=#d3869b
      
      # Cyan
      palette = 6=#689d6a
      palette = 14=#8ec07c
      
      # White
      palette = 7=#a89984
      palette = 15=#ebdbb2
      
      # ============================================
      # FONT CONFIGURATION
      # ============================================
      
      font-family = JetBrains Mono
      font-size = 12
      font-feature = -calt
      font-feature = -liga
      
      # Font variations
      font-style = Regular
      font-style-bold = Bold
      font-style-italic = Italic
      font-style-bold-italic = Bold Italic
      
      # ============================================
      # WINDOW & APPEARANCE
      # ============================================
      
      # Window padding
      window-padding-x = 8
      window-padding-y = 8
      window-padding-balance = true
      
      # Window decorations
      window-decoration = true
      window-theme = dark
      
      # Background opacity (1.0 = opaque, 0.0 = transparent)
      background-opacity = 0.95
      unfocused-split-opacity = 0.7
      
      # Cursor
      cursor-style = block
      cursor-style-blink = true
      
      # ============================================
      # TERMINAL BEHAVIOR
      # ============================================
      
      # Shell
      command = ${pkgs.zsh}/bin/zsh
      
      # Scrollback
      scrollback-limit = 10000
      
      # Mouse
      mouse-hide-while-typing = true
      
      # Copy/Paste
      copy-on-select = true
      
      # Links
      link-url = true
      
      # ============================================
      # KEYBINDINGS
      # ============================================
      
      # Copy/Paste
      keybind = ctrl+shift+c=copy_to_clipboard
      keybind = ctrl+shift+v=paste_from_clipboard
      
      # Font size
      keybind = ctrl+plus=increase_font_size:1
      keybind = ctrl+minus=decrease_font_size:1
      keybind = ctrl+0=reset_font_size
      
      # Splits
      keybind = ctrl+shift+d=new_split:right
      keybind = ctrl+shift+s=new_split:down
      
      # Navigation
      keybind = ctrl+shift+h=goto_split:left
      keybind = ctrl+shift+j=goto_split:bottom
      keybind = ctrl+shift+k=goto_split:top
      keybind = ctrl+shift+l=goto_split:right
      
      # Tabs
      keybind = ctrl+shift+t=new_tab
      keybind = ctrl+shift+w=close_surface
      keybind = ctrl+tab=next_tab
      keybind = ctrl+shift+tab=previous_tab
      
      # Search
      keybind = ctrl+shift+f=toggle_quick_terminal
      
      # Clear screen
      keybind = ctrl+shift+k=clear_screen
      
      # ============================================
      # ADVANCED SETTINGS
      # ============================================
      
      # Performance
      resize-overlay = never
      
      # Shell integration
      shell-integration = detect
      shell-integration-features = cursor,sudo,title
      
      # Clipboard
      clipboard-read = allow
      clipboard-write = allow
      
      # Desktop notifications
      desktop-notifications = true
      
      # Bold is bright
      bold-is-bright = false
      
      # Minimum contrast
      minimum-contrast = 1.0
    '';
  };
}

