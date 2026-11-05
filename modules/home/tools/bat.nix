{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.features.tools.bat;
in
{
  options.features.tools.bat = {
    enable = mkEnableOption "bat syntax highlighting cat replacement";
  };

  config = mkIf cfg.enable {
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
