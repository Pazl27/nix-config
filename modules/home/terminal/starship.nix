{ config, lib, pkgs, ... }:

with lib;

{
  options.features.terminal.starship = {
    enable = mkEnableOption "starship prompt";
  };

  config = mkIf config.features.terminal.starship.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        add_newline = true;
      };
    };
  };
}