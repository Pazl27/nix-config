{ config, lib, ... }:
let
  inherit (lib) mkDefault;
  wm = config.host.windowManager;
in
{
  imports = [
    ./hyprland
    ./niri
  ];

  # Enable the compositor selected in the host's variables.nix
  features.wm = {
    hyprland.enable = mkDefault (wm == "hyprland");
    niri.enable = mkDefault (wm == "niri");
  };
}
