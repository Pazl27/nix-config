{
  home.stateVersion = "24.05";

  features = {
    scripts.enable = true;

    # === Development Environments ===
    environments = {
      node.enable = true;
      rust.enable = true;
      c.enable = true;
      cpp.enable = true;
    };

    # === Editors ===
    editors.neovim.enable = true;

    # === Terminal Setup ===
    terminal = {
      zsh.enable = true;
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
      tuicr.enable = true;
    };
  };
}
