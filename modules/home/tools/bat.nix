{ config, lib, pkgs, ... }:

with lib;

{
  options.features.tools.bat = {
    enable = mkEnableOption "bat syntax highlighting cat replacement";
  };

  config = mkIf config.features.tools.bat.enable {
    programs.bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark";
        style = "numbers,changes,header";
        italic-text = "always";
        decorations = "always";
        color = "always";
        pager = "less -FR";
      };
    };
  };
}
