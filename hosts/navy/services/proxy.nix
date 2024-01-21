{ config, ... }: {
  # Haze is behind NAT. We therefore proxy to it where relevant
  networking = {
    nftables = { enable = false; };

    firewall = {
      enable = true;
      allowedTCPPorts = [ 10293 ];
    };

    nat = {
      enable = true;
      externalInterface = "ens3";
      internalInterfaces = [ "wg0" ];
      forwardPorts = [{
        destination = "${config.lib.network.hosts.haze.wg.ip}:22";
        proto = "tcp";
        sourcePort = 10293;
      }];
    };
  };

  elia.caddy.bare = true; # Needed to access haze through WG mesh... TODO
  elia.caddy.routes."media.elia.garden".extraConfig = ''
    ${config.lib.caddy.snippets.no-robots}
    reverse_proxy haze:8096
  '';
}
