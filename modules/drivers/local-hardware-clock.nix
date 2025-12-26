{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.hardware.hardware-clock;
in
{
  options.hardware.hardware-clock = {
    enable = mkEnableOption "Change Hardware Clock To Local Time";
  };
  config = mkIf cfg.enable {
    time.hardwareClockInLocalTime = true;
  };
}
