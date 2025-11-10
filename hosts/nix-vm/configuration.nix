{ config, pkgs, ... }:
{
  # VM & Hardware
  vm.guest-services.enable = true;
  drivers.intel.enable = true;

  # Network
  networking.hostName = "nixvm";
  networking.networkmanager.enable = true;

  # Display Server & Desktop
  services.xserver.enable = true;
  services.desktopManager.gnome.enable = true;
  programs.hyprland.enable = true;
  programs.niri.enable = true;

  # Shell
  programs.zsh.enable = true;

  # User
  users.users.nixvm = {
    isNormalUser = true;
    description = "nix-vm";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK2tcTVu+NRaLxji8wk1rngZ0+VvpLj+yfVofpM02nqJ nix-wsl@DESKTOP-QB6O3EE"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkXamJpo/wZPSkCfZzX+LudFhUxBXE1JeUC3Goof9gu paul@endevour"
    ];
  };

  system.stateVersion = "25.05";
}
