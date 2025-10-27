{ config, lib, pkgs, ... }:

with lib;

{
  options.features.terminal.bash = {
    enable = mkEnableOption "bash shell configuration";
  };

  config = mkIf config.features.terminal.bash.enable {
    programs.bash = {
      enable = true;

    };
  };
}