{ ... }: {
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.adguardhome = {
    enable = true;
    allowDHCP = true;
  };

  # Persist files
  systemd.tmpfiles.rules =
    [ "L /var/lib/AdGuardHome - - - - /persist/data/adguardhome" ];
}
