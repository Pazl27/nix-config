{ config, pkgs, ... }:
{

  drivers = {
    nvidia.enable = true;
    amdgpu.enable = false;
    intel.enable = false;
    nvidia-prime.enable = false;
  };

  hardware = {
    hardware-clock.enable = true;

    wooting.enable = true;
    finalmouse.enable = true;
    logitech.wireless.enable = true;
  };
  core.steam.enable = true;

  # Network
  networking.hostName = "desktop";
  networking.networkmanager.enable = true;

  # Display Server & Desktop
  services.xserver.enable = true;
  services.desktopManager.gnome.enable = false;
  programs.hyprland.enable = true;
  programs.niri.enable = false;

  # Shell
  programs.zsh.enable = true;

  # User
  virtualisation.docker.enable = true;
  users.users.desktop = {
    isNormalUser = true;
    description = "desktop";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  system.stateVersion = "25.05";
}
