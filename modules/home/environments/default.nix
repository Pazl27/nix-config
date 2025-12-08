{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./c.nix
    ./cpp.nix
    ./go.nix
    ./java.nix
    ./node.nix
    ./python.nix
    ./rust.nix
    ./database.nix
    ./docker.nix
  ];
}
