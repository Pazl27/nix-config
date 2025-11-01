{
  config,
  lib,
  pkgs,
  ...
}:
{
  # ============================================
  # FIREWALL CONFIGURATION
  # ============================================
  networking.firewall = {
    enable = true;

    # Ports werden in der configuration.nix definiert
    allowedTCPPorts = [ ]; # Hier nichts, wird pro System gesetzt
    allowedUDPPorts = [ ];

    # Allow ping
    allowPing = true;

    # Logging disabled for performance
    logRefusedConnections = false;
    logRefusedPackets = false;
    logReversePathDrops = false;

    # Advanced firewall rules
    extraCommands = ''
      # === DROP INVALID PACKETS ===
      iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
      ip6tables -A INPUT -m conntrack --ctstate INVALID -j DROP

      # === ALLOW ESTABLISHED CONNECTIONS ===
      iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
      ip6tables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

      # === ALLOW LOOPBACK ===
      iptables -A INPUT -i lo -j ACCEPT
      ip6tables -A INPUT -i lo -j ACCEPT

      # === SSH RATE LIMITING (Anti Brute-Force) ===
      iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set --name SSH
      iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --hitcount 4 --name SSH -j DROP

      # === PROTECTION AGAINST PORT SCANNING ===
      iptables -N port-scan 2>/dev/null || true
      iptables -A port-scan -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURN
      iptables -A port-scan -j DROP

      # === PROTECTION AGAINST SYN FLOOD ===
      iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

      # === DROP FRAGMENTED PACKETS ===
      iptables -A INPUT -f -j DROP

      # === DROP XMAS PACKETS ===
      iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

      # === DROP NULL PACKETS ===
      iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
    '';

    extraStopCommands = ''
      # Cleanup custom chains
      iptables -F port-scan 2>/dev/null || true
      iptables -X port-scan 2>/dev/null || true
    '';
  };

  # ============================================
  # SSH HARDENING
  # ============================================
  services.openssh = lib.mkIf config.services.openssh.enable {
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

    # Security banner
    banner = ''
      ╔═══════════════════════════════════════════╗
      ║   AUTHORIZED ACCESS ONLY                  ║
      ║   All activity is logged and monitored    ║
      ║   Unauthorized access is prohibited       ║
      ╚═══════════════════════════════════════════╝
    '';
  };

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
  # KERNEL HARDENING
  # ============================================
  boot.kernel.sysctl = {
    # === NETWORK SECURITY ===

    # Disable IP forwarding
    "net.ipv4.ip_forward" = 0;
    "net.ipv6.conf.all.forwarding" = 0;

    # SYN flood protection
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_syn_retries" = 2;
    "net.ipv4.tcp_synack_retries" = 2;
    "net.ipv4.tcp_max_syn_backlog" = 4096;

    # Don't accept ICMP redirects
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;

    # Don't send ICMP redirects
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;

    # Don't accept source routing
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.default.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.default.accept_source_route" = 0;

    # Reverse path filtering (anti IP spoofing)
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;

    # Ignore ICMP echo requests to broadcast/multicast
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;

    # Ignore bogus ICMP error responses
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;

    # Log martian packets
    "net.ipv4.conf.all.log_martians" = 0;
    "net.ipv4.conf.default.log_martians" = 0;

    # TCP hardening
    "net.ipv4.tcp_timestamps" = 1;
    "net.ipv4.tcp_sack" = 1;
    "net.ipv4.tcp_window_scaling" = 1;
    "net.ipv4.tcp_rfc1337" = 1;

    # === KERNEL SECURITY ===

    # Restrict kernel pointer exposure
    "kernel.kptr_restrict" = 2;

    # Restrict dmesg to root
    "kernel.dmesg_restrict" = 1;

    # Restrict access to kernel logs
    "kernel.printk" = "3 3 3 3";

    # Disable kexec
    "kernel.kexec_load_disabled" = 1;

    # Enable ASLR
    "kernel.randomize_va_space" = 2;

    # Restrict ptrace
    "kernel.yama.ptrace_scope" = 1;

    # === FILESYSTEM SECURITY ===

    # Restrict core dumps
    "fs.suid_dumpable" = 0;

    # Increase inotify limits
    "fs.inotify.max_user_watches" = 524288;
  };

  # ============================================
  # SYSTEM HARDENING
  # ============================================

  # Restrict access to su
  security.sudo = {
    execWheelOnly = true;
    wheelNeedsPassword = true;
    extraConfig = ''
      Defaults lecture = never
      Defaults timestamp_timeout = 15
    '';
  };

  # ============================================
  # SECURITY PACKAGES
  # ============================================
  environment.systemPackages = with pkgs; [
    iptables
    fail2ban
  ];

  # ============================================
  # SYSTEM MAINTENANCE
  # ============================================
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.optimise.automatic = true;

  # ============================================
  # ADDITIONAL HARDENING
  # ============================================

  # Disable coredumps
  systemd.coredump.enable = false;

}
