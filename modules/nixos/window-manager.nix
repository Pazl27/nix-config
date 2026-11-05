{ config, lib, ... }:
let
  inherit (lib) mkIf;
  wm = config.host.windowManager;
in
{
  config = mkIf (wm != null) {
    services.xserver.enable = true;
    programs.hyprland.enable = wm == "hyprland";
    programs.niri.enable = wm == "niri";
  };
}
