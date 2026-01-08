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

    #  localsend
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [
      53317
      5353
    ];

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

      # === PROTECTION AGAINST PORT SCANNING ===
      iptables -N port-scan 2>/dev/null || true
      iptables -A port-scan -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURN
      iptables -A port-scan -j DROP

      # === PROTECTION AGAINST SYN FLOOD ===
      iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

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
  # KERNEL HARDENING
  # ============================================
  boot.kernel.sysctl = {
    # === NETWORK SECURITY ===

    # Disable IP forwarding
    "net.ipv4.ip_forward" = 0;
    "net.ipv6.conf.all.forwarding" = 0;

    # SYN flood protection
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_syn_retries" = 4;
    "net.ipv4.tcp_synack_retries" = 4;
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

    # Disable core pattern
    "kernel.core_pattern" = "|/bin/false";
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
  # NETWORK
  # ============================================
  # Avahi disabled to prevent network broadcast interference during gaming
  services.avahi = {
    enable = false;
    nssmdns4 = true;
    openFirewall = true;
  };

  # ============================================
  # ADDITIONAL HARDENING
  # ============================================

  # Disable coredumps
  systemd.coredump.enable = false;

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "core";
      value = "0";
    }
    {
      domain = "*";
      type = "hard";
      item = "core";
      value = "0";
    }
  ];
}
