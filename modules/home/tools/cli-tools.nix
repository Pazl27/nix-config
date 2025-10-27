{ config, lib, pkgs, ... }:

with lib;

{
  options.features.tools.cliTools = {
    enable = mkEnableOption "modern CLI tools collection";
  };

  config = mkIf config.features.tools.cliTools.enable {
    home.packages = with pkgs; [
      # Modern replacements
      eza        # Better ls
      ripgrep    # Better grep
      fd         # Better find
      fzf        # Fuzzy finder
      zoxide     # Better cd

      # Utilities
      tree
      wget
      curl
      jq         # JSON processor
      yq-go      # YAML processor
      yazi

      # Compression
      unzip
      zip

      # Misc
      tldr       # Simplified man pages
    ];

    # Configure zoxide
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    # Configure fzf
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "${pkgs.fd}/bin/fd --type f";
      fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
    };
  };
}
