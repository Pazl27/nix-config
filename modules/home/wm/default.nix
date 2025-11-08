{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./niri
    ./hyprland
  ];
}
