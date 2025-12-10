{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.features.environments.zig;
in
{
  options.features.environments.zig = {
    enable = mkEnableOption "Zig development environment";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zig
      zls # Zig Language Server
    ];
  };
}
