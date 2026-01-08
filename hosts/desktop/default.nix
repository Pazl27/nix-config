{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (import ./variables.nix) window_manager;

  # Determine which window managers to enable
  enableHyprland = window_manager == "hyprland" || window_manager == "";
  enableNiri = window_manager == "niri";
in
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  # Display Server & Desktop
  services.xserver.enable = true;
  services.desktopManager.gnome.enable = false;
  programs.hyprland.enable = enableHyprland;
  programs.niri.enable = enableNiri;

  system.stateVersion = "25.05";
}
