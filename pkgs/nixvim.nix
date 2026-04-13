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
nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvimWithModule {
  inherit pkgs;
  module = nixvimConfig;
}
