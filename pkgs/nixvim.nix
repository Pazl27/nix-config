{
  pkgs,
  nixvim,
  lib ? pkgs.lib,
  ...
}:

let
  nixvimConfig = {
    imports = [ ../modules/home/editors/nvim/config ];
  };
in
nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule {
  inherit pkgs;
  module = nixvimConfig;
}
