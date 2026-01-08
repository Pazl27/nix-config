{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (import ./variables.nix) window_manager;

  # Determine which window managers to enable
  enableHyprland = window_manager == "hyprland" || window_manager == "";
  enableNiri = window_manager == "niri";
in
{
  # Features für Home Manager
  features = {
    # === Development Environments ===
    environments = {
      node.enable = true;
      python.enable = false;
      rust.enable = false;
      go.enable = false;
      java.enable = true;
      c.enable = false;
      cpp.enable = true;
      database = {
        enable = true;
        gui = true;
        cli = false;
      };
      docker.enable = true;
      zig.enable = false;
    };
    wm = {
      niri.enable = enableNiri;
      hyprland = {
        enable = enableHyprland;
        hyprlock.enable = enableHyprland;
      };
    };
    # === Editors ===
    editors = {
      neovim.enable = true;
      zed.enable = true;
    };
    # === Terminal Setup ===
    terminal = {
      zsh.enable = true;
      bash.enable = false;
      tmux.enable = true;
      starship.enable = true;
    };
    # === Development Tools ===
    tools = {
      git.enable = true;
      cliTools.enable = true;
      direnv.enable = true;
      fastfetch.enable = true;
      bat.enable = true;
      ssh.enable = true;
      yazi.enable = true;
      pokemon.enable = false;
    };
    # === Applications ===
    application = {
      kitty.enable = true;
      ghostty.enable = true;
      thunar.enable = true;
      gtk.enable = true;
      discord.enable = true;
      spotify.enable = true;
      obs.enable = true;
      firefox = {
        enable = true;
        default = true;
      };
      prismlauncher = {
        enable = true;
      };
      apps = {
        enable = true;
        apps = with pkgs; [
          gimp
          kdePackages.kolourpaint
          drawio

          claude-code
          vial
          postman
          obsidian

          ferdium
          localsend
          keepass

          vlc
          abiword
          kdePackages.okular
          libreoffice-fresh
        ];
      };
    };
  };
}
