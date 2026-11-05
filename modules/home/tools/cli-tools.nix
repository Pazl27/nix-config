{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.features.tools.cliTools;
in
{
  options.features.tools.cliTools = {
    enable = mkEnableOption "modern CLI tools collection";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Modern replacements
      eza # Better ls
      ripgrep # Better grep
      fd # Better find
      fzf # Fuzzy finder
      zoxide # Better cd
      serie

      # Utilities
      tree
      wget
      curl
      jq # JSON processor
      yq-go # YAML processor
      yazi
      gum

      # Compression
      unzip
      zip

      # Misc
      tldr # Simplified man pages
      glow
    ];
  };
}
