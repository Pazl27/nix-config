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

      # SSH config for different hosts (OpenSSH directive names)
      settings = {
        # GitHub
        "github.com" = {
          HostName = "github.com";
          User = "git";
          IdentityFile = "~/.ssh/github";
          IdentitiesOnly = true;
        };
        # GitLab
        "gitlab.com" = {
          HostName = "gitlab.com";
          User = "git";
          IdentityFile = "~/.ssh/gitlab";
          IdentitiesOnly = true;
        };
        # Wildcard for all other hosts
        "*" = {
          # Global SSH config options
          Compression = true;
          ServerAliveInterval = 60;
          ServerAliveCountMax = 5;
          # Use SSH agent
          AddKeysToAgent = "yes";
          # Reuse connections for speed
          ControlMaster = "auto";
          ControlPath = "~/.ssh/control-%r@%h:%p";
          ControlPersist = "10m";
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
