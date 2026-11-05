# Entry point of the NixOS module tree. The base system (boot, locale,
# audio, nix, hardening, fonts) is always on; everything else is toggled
# through `features.*` or derived from `config.host`.
{
  imports = [
    ./bluetooth.nix
    ./bootloader.nix
    ./display-manager.nix
    ./fonts.nix
    ./openssh.nix
    ./packages.nix
    ./security.nix
    ./steam.nix
    ./system.nix
    ./window-manager.nix
  ];
}
