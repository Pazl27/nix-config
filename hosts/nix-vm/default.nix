{
  config,
  lib,
  pkgs,
  ...
}:

let
  vars = import ./variables.nix { inherit pkgs; };
in
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  # Nur hostVars für NixOS-Module wie bootloader.nix
  options.hostVars = lib.mkOption {
    type = lib.types.attrs;
    default = vars;
  };

  config.hostVars = vars;
}
