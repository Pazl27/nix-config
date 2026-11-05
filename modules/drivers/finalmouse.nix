{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.drivers.finalmouse;
in
{
  options.drivers.finalmouse = {
    enable = mkEnableOption "udev rules for Finalmouse devices";
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.finalmouse-udev-rules ];
  };
}
