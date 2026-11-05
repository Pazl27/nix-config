{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.features.editors.neovim;
in
{
  options.features.editors.neovim = {
    enable = mkEnableOption "Neovim with NixVim configuration";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      nixpkgs.pkgs = pkgs;
      imports = [
        ./config
      ];
    };
  };
}
