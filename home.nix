{
  config,
  pkgs,
  lib,
  inputs,
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
    ./modules/home/tools/yazi.nix

    # applications
    ./modules/home/applications/kitty.nix
    ./modules/home/applications/thunar.nix
    ./modules/home/applications/gtk.nix
    ./modules/home/applications/ghostty.nix
    ./modules/home/applications/rofi.nix
    ./modules/home/applications/swaync.nix
    ./modules/home/applications/waybar.nix
    ./modules/home/applications/wlogout.nix
    ./modules/home/applications/discord.nix
    ./modules/home/applications/spotify.nix
    ./modules/home/applications/brave.nix

    # wm
    ./modules/home/wm
  ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
