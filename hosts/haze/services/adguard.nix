{ ... }:
{
  networking.firewall.allowedTCPPorts = [
    53
    3000
  ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.adguardhome = {
    enable = true;
    allowDHCP = true;
    mutableSettings = false;
    settings = {
      dns = {
        bind_hosts = [ "0.0.0.0" ];
        allowed_clients = [
          "10.0.0.0/8"
          "192.168.0.0/16"
        ];
        port = 53;
        ratelimit = 0;

        # Quad9
        upstream_dns = [ "tls://dns.quad9.net" ];
        bootstrap_dns = [ "9.9.9.9" ];
        fallback_dns = [ "9.9.9.9" ];
        enable_dnssec = true;
      };

      filtering = {
        protection_enabled = true;
        filtering_enabled = true;
      };
      statistics.enabled = true;
    };
  };

  # Persist files
  elia.persist."adguard" = {
    path = "/var/lib/private/AdGuardHome";
    kind = "data";
    owner = "adguardhome";
    group = "adguardhome";
  };
}
