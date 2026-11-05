{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.features.scripts;
in
{
  options.features.scripts = {
    enable = mkEnableOption "personal scripts in ~/.config/scripts (rofi menus, tmux helpers, installers)";
  };

  config = mkIf cfg.enable {
    xdg.configFile."scripts".source = "${pkgs.my-scripts}/share/scripts";
  };
}
