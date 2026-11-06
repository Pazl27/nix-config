# Entry point of the NixOS module tree. The base system (boot, locale,
# nix, hardening) is always on; everything else is toggled through
# `features.*` or derived from `config.host`. The desktop base (audio,
# fonts, ...) follows `host.windowManager`.
{
  imports = [
    ./bluetooth.nix
    ./bootloader.nix
    ./desktop.nix
    ./display-manager.nix
    ./fonts.nix
    ./homelab.nix
    ./openssh.nix
    ./packages.nix
    ./security.nix
    ./steam.nix
    ./system.nix
    ./window-manager.nix
  ];
}
