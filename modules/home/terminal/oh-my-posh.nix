{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.features.terminal.oh-my-posh = {
    enable = mkEnableOption "oh-my-posh prompt";
  };

  config = mkIf config.features.terminal.oh-my-posh.enable {

    programs.oh-my-posh = {
      enable = true;
      useTheme = "gruvbox";

      enableZshIntegration = true;
    };

  };
}
