{ config, lib, pkgs, ... }:
{
  # Services
  features.openssh.enable = true;

  # Network
  networking.hostName = config.host.name;

  # Deploys push closures as the primary user
  nix.settings.trusted-users = [
    "root"
    config.host.username
  ];

  # ponytail: no password for the user, so sudo can't ask for one; SSH is key-only
  # and a trusted Nix user is root-equivalent anyway. Upgrade path: a sops secret with
  # neededForUsers = true as hashedPasswordFile, then drop this.
  security.sudo.wheelNeedsPassword = lib.mkForce false;

  # User
  programs.zsh.enable = true;
  users.users.${config.host.username} = {
    isNormalUser = true;
    description = config.host.username;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
  };
}
