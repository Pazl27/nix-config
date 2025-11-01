{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.features.tools.ssh = {
    enable = mkEnableOption "SSH configuration and key management";
  };
  config = mkIf config.features.tools.ssh.enable {
    # Add openssh package for ssh-keygen and other SSH tools
    home.packages = with pkgs; [
      openssh
    ];

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      # SSH config for different hosts
      matchBlocks = {
        # GitHub
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/github";
          identitiesOnly = true;
        };
        # GitLab
        "gitlab.com" = {
          hostname = "gitlab.com";
          user = "git";
          identityFile = "~/.ssh/gitlab";
          identitiesOnly = true;
        };
        # Wildcard for all other hosts
        "*" = {
          # Global SSH config options
          compression = true;
          serverAliveInterval = 60;
          serverAliveCountMax = 5;
          # Use SSH agent
          addKeysToAgent = "yes";
          # Reuse connections for speed
          controlMaster = "auto";
          controlPath = "~/.ssh/control-%r@%h:%p";
          controlPersist = "10m";
        };
      };
    };
    # SSH Agent service (keeps your keys loaded)
    services.ssh-agent = {
      enable = true;
    };
    # Add helpful aliases to zsh
    programs.zsh.shellAliases = mkIf config.features.terminal.zsh.enable {
      ssh-list = "ls -la ~/.ssh/*.pub";
      ssh-test = "ssh -T git@github.com";
    };
  };
}
