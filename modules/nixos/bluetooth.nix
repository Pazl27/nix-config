{
  config,
  pkgs,
  lib,
  ...
}:
{
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
}
