{
  home.stateVersion = "26.05";

  features = {
    # === Editors ===
    editors.neovim.enable = true;

    # === Terminal Setup ===
    terminal = {
      zsh.enable = true;
      tmux.enable = true;
      starship.enable = true;
    };

    # === Tools ===
    tools = {
      git.enable = true;
      cliTools.enable = true;
      bat.enable = true;
      yazi.enable = true;
    };
  };
}
