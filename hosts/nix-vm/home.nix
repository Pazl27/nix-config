{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Features für Home Manager
  features = {
    # === Development Environments ===
    environments = {
      node.enable = true;
      python.enable = false;
      rust.enable = false;
      go.enable = false;
      java.enable = false;
      c.enable = false;
      cpp.enable = false;
    };
    wm = {
      niri.enable = true;
      hyprland.enable = true;
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
    };
    # === Applications ===
    application = {
      kitty.enable = true;
      ghostty.enable = true;
      thunar.enable = true;
      gtk.enable = true;
    };
  };
}
