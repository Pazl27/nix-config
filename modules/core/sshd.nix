{ config, pkgs, ... }:
{
  # SSH Server (sshd)
  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;

      X11Forwarding = false;
      PermitEmptyPasswords = false;
      ChallengeResponseAuthentication = false;
    };

    ports = [ 22 ];

  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [
      "127.0.0.1/8"
      "192.168.1.0/24"
    ];
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };
}
