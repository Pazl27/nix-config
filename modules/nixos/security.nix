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

      # === ALLOW ESTABLISHED CONNECTIONS ===
      iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

      # === ALLOW LOOPBACK ===
      iptables -A INPUT -i lo -j ACCEPT

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
    # === IPv6 DISABLE (broken connectivity) ===
    "net.ipv6.conf.all.disable_ipv6" = 1;
    "net.ipv6.conf.default.disable_ipv6" = 1;

    # === NETWORK SECURITY ===
    "net.ipv4.ip_forward" = 0;

    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_syn_retries" = 4;
    "net.ipv4.tcp_synack_retries" = 4;
    "net.ipv4.tcp_max_syn_backlog" = 4096;

    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;

    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;

    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.default.accept_source_route" = 0;

    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    "net.ipv4.conf.all.log_martians" = 0;
    "net.ipv4.conf.default.log_martians" = 0;
    "net.ipv4.tcp_timestamps" = 1;
    "net.ipv4.tcp_sack" = 1;
    "net.ipv4.tcp_window_scaling" = 1;
    "net.ipv4.tcp_rfc1337" = 1;

    # === GAMING NETWORK OPTIMIZATIONS ===
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
    "net.core.netdev_max_backlog" = 5000;
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_mtu_probing" = 1;
    "net.ipv4.tcp_fin_timeout" = 15;

    # === KERNEL SECURITY ===
    "kernel.kptr_restrict" = 2;
    "kernel.dmesg_restrict" = 1;
    "kernel.printk" = "3 3 3 3";
    "kernel.kexec_load_disabled" = 1;
    "kernel.randomize_va_space" = 2;
    "kernel.yama.ptrace_scope" = 1;

    # === FILESYSTEM SECURITY ===
    "fs.suid_dumpable" = 0;
    "fs.inotify.max_user_watches" = 524288;
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
