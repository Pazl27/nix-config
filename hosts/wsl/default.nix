{
  config,
  lib,
  pkgs,
  ...
}:

{
  # ============================================
  # WSL Configuration - Enable/Disable Features
  # ============================================

  "features" = {
    # === Environments ===
    environments = {
      node.enable = true;
      python.enable = false;
      rust.enable = true;
      go.enable = false;
      java.enable = false;
      c.enable = true;
      cpp.enable = true;
    };

    # === Editors ===
    editors = {
      neovim.enable = true;
    };

    # === Terminal ===
    terminal = {
      zsh.enable = true;
      bash.enable = false;
      tmux.enable = true;
      starship.enable = true;
      oh-my-posh.enable = false;
    };

    # === Tools ===
    tools = {
      git.enable = true;
      cliTools.enable = true;
      direnv.enable = true;
      fastfetch.enable = true;
      bat.enable = true;
      ssh.enable = true;
      yazi.enable = true;
    };
  };
}
