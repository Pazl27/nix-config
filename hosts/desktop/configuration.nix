{ config, pkgs, ... }:
{
  # Hardware
  # GPU drivers follow `host.gpu` from ./variables.nix
  drivers.finalmouse.enable = true;
  hardware = {
    wooting.enable = true;
    logitech.wireless.enable = true;
  };

  # Dual boot with Windows, which keeps the RTC in local time
  time.hardwareClockInLocalTime = true;

  # Services
  features = {
    bluetooth.enable = true;
    openssh.enable = true;
    steam.enable = true;
  };
  virtualisation.docker.enable = true;

  # Network
  networking.hostName = config.host.name;
  networking.networkmanager.enable = true;

  # User
  programs.zsh.enable = true;
  users.users.${config.host.username} = {
    isNormalUser = true;
    description = config.host.username;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };
}
