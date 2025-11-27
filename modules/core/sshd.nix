{
  config,
  pkgs,
  host,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) sshAuthorizedKeys;
in
{
  # ============================================
  # SSH SERVER CONFIGURATION
  # ============================================
  services.openssh = {
    enable = true;

    ports = [ 22 ];

    settings = {
      # === AUTHENTICATION ===
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      ChallengeResponseAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitEmptyPasswords = false;
      PubkeyAuthentication = true;

      # === SECURITY ===
      X11Forwarding = false;
      AllowAgentForwarding = true;
      AllowTcpForwarding = true;
      PermitUserEnvironment = false;

      # === CONNECTION LIMITS ===
      MaxAuthTries = 3;
      MaxSessions = 10;
      LoginGraceTime = 30;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;

      # === MODERN CRYPTOGRAPHY ===
      KexAlgorithms = [
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group16-sha512"
        "diffie-hellman-group18-sha512"
        "diffie-hellman-group-exchange-sha256"
      ];

      Ciphers = [
        "chacha20-poly1305@openssh.com"
        "aes256-gcm@openssh.com"
        "aes128-gcm@openssh.com"
        "aes256-ctr"
        "aes192-ctr"
        "aes128-ctr"
      ];

      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
      ];
    };
  };

  # ============================================
  # AUTHORIZED KEYS
  # ============================================
  # Authorized keys - host is username
  users.users.${host}.openssh.authorizedKeys.keys = sshAuthorizedKeys;

  # ============================================
  # FAIL2BAN (Anti Brute-Force)
  # ============================================
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";

    # Progressive ban time
    bantime-increment = {
      enable = true;
      maxtime = "168h"; # 1 week max
      factor = "2";
    };

    # Don't ban local networks
    ignoreIP = [
      "127.0.0.0/8"
      "10.0.0.0/8"
      "172.16.0.0/12"
      "192.168.0.0/16"
    ];
  };

  # ============================================
  # FIREWALL - SSH SPECIFIC
  # ============================================
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];

    # SSH rate limiting (Anti Brute-Force)
    extraCommands = ''
      # === SSH RATE LIMITING (Anti Brute-Force) ===
      iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set --name SSH
      iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --hitcount 4 --name SSH -j DROP
    '';
  };
}
