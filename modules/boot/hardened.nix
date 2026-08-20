{
  flake.modules.nixos.hardened = {
    lib,
    config,
    ...
  }:
    with lib; let
      cfg = config.mySystem.boot.kernel;
    in {
      options.mySystem.boot.kernel.hardened = mkEnableOption "Enables hardened Linux kernel";

      config.boot = {
        kernelModules = lists.optional cfg.hardened "tcp_bbr";
        kernel.sysctl = mkIf cfg.hardened {
          "kernel.sysrq" = 0; # Disable magic SysRq key
          # Ignore ICMP broadcasts to avoid participating in Smurf attacks
          "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
          # Ignore bad ICMP errors
          "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
          # SYN flood protection
          "net.ipv4.tcp_syncookies" = 1;
          # Do not accept ICMP redirects (prevent MITM attacks)
          "net.ipv4.conf.all.accept_redirects" = 0;
          "net.ipv4.conf.default_accept_redirects" = 0;
          "net.ipv4.conf.all.secure_redirects" = 0;
          "net.ipv4.conf.default.secure_redirects" = 0;
          "net.ipv6.conf.all.accept_redirects" = 0;
          "net.ipv6.conf.default.accept_redirects" = 0;
          # Do not send ICMP redirects (we are not a router)
          "net.ipv4.conf.all.send_redirects" = 0;
          # Do not accept IP source route packets (we are not a router)
          "net.ipv4.conf.all.accept_source_route" = 0;
          "net.ipv6.conf.all.accept_source_route" = 0;
          # Protect against tcp time-wait assassination hazards
          "net.ipv4.tcp_rfc1337" = 1;
          # Latency reduction
          "net.ipv4.tcp_fastopen" = 3;
          # Bufferfloat mitigations
          "net.ipv4.tcp_congestion_control" = "bbr";
          "net.core.default_qdisc" = "cake";
        };
      };
    };
}
