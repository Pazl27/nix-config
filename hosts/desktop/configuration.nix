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
  programs.niri.enable = true;

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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK2tcTVu+NRaLxji8wk1rngZ0+VvpLj+yfVofpM02nqJ nix-wsl@DESKTOP-QB6O3EE"
    ];
  };

  system.stateVersion = "25.05";
}
