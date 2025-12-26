{
    lib,
    pkgs,
    config,
    ...
}:
  with lib;
  let
    cfg = config.hardware.finalmouse;
  in
{
    options.hardware.finalmouse = {
      enable = mkEnableOption "Enable finalmouse udev support";
  };
  config = mkIf cfg.enable {
  services.udev.packages = [ pkgs.finalmouse-udev-rules ];
  };
}

