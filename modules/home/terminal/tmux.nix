{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.features.terminal.tmux = {
    enable = mkEnableOption "tmux terminal multiplexer";
  };
  config = mkIf config.features.terminal.tmux.enable {
    programs.tmux = {
      enable = true;
      terminal = "screen-256color";
      prefix = "C-b";
      escapeTime = 0;
      historyLimit = 25000;
      mouse = true;
      baseIndex = 1;
      keyMode = "vi";
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = tmux-fzf;
          extraConfig = ''
            set-option -g @fzf-goto-session-only 'true'
            set -g @fzf-goto-session 'f'
          '';
        }
        vim-tmux-navigator
      ];
      extraConfig = ''
        unbind f
        set -ga terminal-overrides ",screen-256color*:Tc"
        set-option -g default-terminal "screen-256color"
        set -s escape-time 0
        set -gq allow-passthrough on
        set -g visual-activity off
        set -g prefix C-b
        set -g mouse on
        set-option -g history-limit 25000
        set -g set-clipboard on

        # Pane navigation
        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R

        # ===========================
        # Copy Mode Configuration
        # ===========================

        # Enter copy mode with prefix + v
        bind-key v copy-mode

        # Start selection with v
        bind-key -T copy-mode-vi v send-keys -X begin-selection

        # Copy with y (yank) - kopiert zu wl-copy UND tmux buffer
        bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"

        # Copy with Enter - alternative
        bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "wl-copy"

        # Mouse drag also copies to clipboard
        bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "wl-copy"

        # Exit copy mode with q or Escape
        bind-key -T copy-mode-vi q send-keys -X cancel

        # Status bar
        set -g status-right "#(pomo)"
        set -g status-style "fg=#437E81"
        set -g status-left-style "fg=#928374"
        set -g status-position top
        set -g status-bg default
        set -g status-interval 1
        set -g status-left ""

        # Count the panes from 1
        set -g base-index 1
        setw -g pane-base-index 1

        set-option -g default-shell ${pkgs.zsh}/bin/zsh
        set-option -sa terminal-overrides ",xterm*:Tc"
      '';
    };

    # Install additional packages
    home.packages = with pkgs; [
      fzf
      wl-clipboard
    ];
  };
}
