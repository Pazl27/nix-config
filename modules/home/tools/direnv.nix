{ config, lib, pkgs, ... }:

with lib;

{
  options.features.tools.direnv = {
    enable = mkEnableOption "direnv for per-directory environments";
  };

  config = mkIf config.features.tools.direnv.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}