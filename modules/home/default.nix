# Entry point of the Home Manager module tree. Every module is opt-in
# through `features.*`; hosts enable what they need in hosts/<name>/home.nix.
{
  imports = [
    ./applications
    ./editors
    ./environments
    ./terminal
    ./tools
    ./wm
    ./scripts.nix
  ];

  programs.home-manager.enable = true;
}
