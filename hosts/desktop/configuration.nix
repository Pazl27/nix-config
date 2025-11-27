{ config, pkgs, ... }:
{

  drivers.nvidia.enable = true;
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
  users.users.desktop = {
    isNormalUser = true;
    description = "desktop";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  system.stateVersion = "25.05";
}
