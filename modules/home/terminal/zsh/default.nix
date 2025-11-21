{
  config,
  lib,
  pkgs,
  inputs ? { },
  ...
}:

with lib;

{
  options.features.terminal.zsh = {
    enable = mkEnableOption "zsh shell configuration";
  };

  config = mkIf config.features.terminal.zsh.enable {
    programs.zsh = {
      enable = true;

      # History settings (matching your original config)
      history = {
        size = 5000;
        save = 5000;
        path = "${config.home.homeDirectory}/.zsh_history";
        ignoreDups = true;
        ignoreAllDups = true;
        ignoreSpace = true;
        extended = true;
        share = true;
      };

      shellAliases = {
        # Modern CLI tools
        ll = "${pkgs.eza}/bin/eza -la --icons";
        ls = "${pkgs.eza}/bin/eza --icons";
        tree = "${pkgs.eza}/bin/eza -1A --group-directories-first --color=always --git-ignore --tree";
        vi = "nvim";
        vim = "nvim";
        c = "clear";

        # Git
        gl = "${pkgs.git}/bin/git log --graph --pretty=format:'%C(magenta)%h %C(white)%an  %ar%C(blue)  %D%n%s%n'";

        # Home Manager
        hms = "home-manager switch --flake ~/nix-config#$(whoami)";
        hme = "nvim ~/nix-config/hosts/$(hostname)/default.nix";

        nos = "sudo nixos-rebuild switch --flake ~/nix-config#$(hostname)";

        # Common shortcuts
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
      };

      # Color man pages function and other shell functions
      initContent = ''
        # Color man pages
        man() {
          GROFF_NO_SGR=1 \
          LESS_TERMCAP_mb=$'\e[31m' \
          LESS_TERMCAP_md=$'\e[34m' \
          LESS_TERMCAP_me=$'\e[0m' \
          LESS_TERMCAP_se=$'\e[0m' \
          LESS_TERMCAP_so=$'\e[1;30m' \
          LESS_TERMCAP_ue=$'\e[0m' \
          LESS_TERMCAP_us=$'\e[35m' \
          command man "$@"
        }

        # Emacs-style keybindings (matching your original config)
        bindkey -e
        bindkey '^p' history-search-backward
        bindkey '^n' history-search-forward

        # Better history search
        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down
        bindkey '^[[Z' reverse-menu-complete

        # Better completion styling
        zstyle ':completion:*' menu select
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"

        # pokemon-icat
      '';

      localVariables = {
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=13,underline";
        ZSH_AUTOSUGGEST_STRATEGY = [
          "history"
          "completion"
        ];
        KEYTIMEOUT = 1;
      };

      # Enable built-in features
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;

      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
        }
      ];
    };

    # Install required packages for integrations
    home.packages = with pkgs; [
      fzf
      zoxide
      # oh-my-posh
    ];
    # ++ lib.optionals (inputs ? pokemon-icat) [
    #   inputs.pokemon-icat.packages.${pkgs.system}.default
    # ];

    # FZF integration
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    # Zoxide integration
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
  };
}
