{ pkgs, ... }:
{
  home.stateVersion = "24.05";

  # The window manager (and its bar, launcher, lock screen, ...) follows
  # `host.windowManager` from ./variables.nix.
  features = {
    scripts.enable = true;

    # === Development Environments ===
    environments = {
      node.enable = true;
      python.enable = true;
      go.enable = true;
      java.enable = true;
      cpp.enable = true;
      database = {
        enable = true;
        gui = true;
        cli = true;
      };
      docker.enable = true;
    };

    # === Editors ===
    editors = {
      neovim.enable = true;
      zed.enable = true;
    };

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
      superfile.enable = true;
      tuicr.enable = true;
    };

    # === Applications ===
    applications = {
      kitty.enable = true;
      ghostty.enable = true;
      thunar.enable = true;
      gtk.enable = true;
      discord.enable = true;
      spotify.enable = true;
      obs.enable = true;
      firefox.enable = true;
      zen = {
        enable = true;
        default = true;
      };
      prismlauncher.enable = true;
      zathura.enable = true;
      apps = {
        enable = true;
        packages = with pkgs; [
          gimp
          kdePackages.kolourpaint
          drawio

          claude-code
          vial
          postman
          obsidian
          proton-vpn

          ferdium
          localsend
          keepass

          vlc
          abiword
          kdePackages.okular
          libreoffice
        ];
      };
    };
  };
}
