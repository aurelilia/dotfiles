let
  hosts = (import ../../../fleet/mixins/network.nix).hosts;
  haze-wg = hosts.haze.wg.ip;
in { ... }: {
  # Haze is behind NAT.
  networking = {
    nftables = {
      enable = false;
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [ 10293 ];
    };

    nat = {
      enable = true;
      externalInterface = "ens3";
      internalInterfaces = [ "wg0" ];
      forwardPorts = [{
        destination = "${haze-wg}:22";
        proto = "tcp";
        sourcePort = 10293;
      }];
    };
  };
}
