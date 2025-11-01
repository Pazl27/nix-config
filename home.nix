{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    # Environments
    ./modules/home/environments

    # Editors
    ./modules/home/editors

    # Terminal
    ./modules/home/terminal/zsh
    ./modules/home/terminal/bash
    ./modules/home/terminal/tmux.nix
    ./modules/home/terminal/starship.nix
    ./modules/home/terminal/oh-my-posh.nix

    # Tools
    ./modules/home/tools/git.nix
    ./modules/home/tools/cli-tools.nix
    ./modules/home/tools/direnv.nix
    ./modules/home/tools/fastfetch.nix
    ./modules/home/tools/bat.nix
    ./modules/home/tools/ssh.nix

    # applications
    ./modules/home/applications/kitty.nix
    ./modules/home/applications/thunar.nix
    ./modules/home/applications/gtk.nix

    # wm
    ./modules/home/wm
  ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
