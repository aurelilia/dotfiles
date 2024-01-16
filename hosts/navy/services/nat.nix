let
  hosts = (import ../../../fleet/mixins/network.nix).hosts;
  haze-wg = hosts.haze.wg.ip;
in { ... }: {
  # Haze is behind NAT.
  networking = {
    nftables = {
      enable = true;
      ruleset = ''
          table ip nat {
            chain PREROUTING {
              type nat hook prerouting priority dstnat; policy accept;
              iifname "ens3" tcp dport 22 dnat to ${haze-wg}:22
            }
          }
      '';
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [ 10293 ];
    };

    nat = {
      enable = true;
      externalInterface = "ens3";
      internalInterfaces = [ "wg0" ];
      internalIPs = [ "10.45.0.0/24" ];
      forwardPorts = [{
        destination = "${haze-wg}:22";
        proto = "tcp";
        sourcePort = 10293;
      }];
    };
  };
}
