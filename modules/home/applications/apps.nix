{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.features.application.apps = {
    enable = mkEnableOption "Simple applications without configuration";

    apps = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "List of simple applications to install";
    };
  };

  config = mkIf config.features.application.apps.enable {
    home.packages = config.features.application.apps.apps;
  };
}
