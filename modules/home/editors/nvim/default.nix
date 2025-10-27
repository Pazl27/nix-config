{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
in {
  options.features.editors.neovim.enable =
    mkEnableOption "Enable Neovim with NixVim configuration";

  config = mkIf config.features.editors.neovim.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      imports = [
        ./config
      ];
    };
  };
}
