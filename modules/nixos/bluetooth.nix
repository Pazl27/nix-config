{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.features.bluetooth;
in
{
  options.features.bluetooth = {
    enable = mkEnableOption "Bluetooth with blueman";
  };

  config = mkIf cfg.enable {
    # Bluetooth Hardware Support
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;

      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };

    # Bluetooth Services
    services.blueman.enable = true;

    # Bluetooth packages
    environment.systemPackages = with pkgs; [
      bluez
      bluez-tools
      blueman
    ];

    # Ensure bluetooth kernel modules are loaded
    boot.kernelModules = [
      "bluetooth"
      "btusb"
    ];
  };
}
