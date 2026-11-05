{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.features.applications.apps;
in
{
  options.features.applications.apps = {
    enable = mkEnableOption "applications that need no further configuration";
    packages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Applications to install as-is.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = cfg.packages;
  };
}
