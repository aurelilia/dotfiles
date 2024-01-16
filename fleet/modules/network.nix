let
  network = import ../mixins/network.nix;
  networks = network.networks;
  hosts = network.hosts;
in { name, config, lib, pkgs, ... }:
let host = (lib.getAttr name hosts);
in {
  config = (lib.mkMerge [
    # General config
    {
      networking = {
        hostName = name;
        fqdn = name + ".elia.garden";
        firewall.enable = lib.mkDefault true;
        extraHosts = lib.concatStringsSep "\n" (lib.attrValues
          (lib.mapAttrs (name: { address, ... }: "${address} ${name}") hosts));
      };
    }

    # Static IPv4
    (lib.mkIf (host ? gateway) {
      networking = {
        useDHCP = false;
        defaultGateway = host.gateway;
        nameservers = host.nameservers;
        interfaces.lan.ipv4.addresses = [{
          address = host.address;
          prefixLength = host.prefix;
        }];
      };

      systemd.network.links."10-lan" = {
        matchConfig.PermanentMACAddress = host.mac;
        linkConfig.Name = "lan";
      };
    })

    # Wireguard
    (lib.mkIf (host ? wg) {
      networking.firewall = {
        allowedUDPPorts = [ 50220 ];
        trustedInterfaces = [ "wg0" ];
      };
      
      networking.wireguard.interfaces = {
        wg0 = {
          ips = [ "${host.wg.ip}/24" ];
          listenPort = 50220;
          privateKeyFile = "/persist/secrets/wireguard/wireguard-private";
          mtu = 1400;

          peers = map (args@{ key, ip, ... }: {
            publicKey = key;
            allowedIPs = [ "${ip}/32" ];
            endpoint = args.endpoint or null;
            persistentKeepalive = (if args ? endpoint then 25 else null);
          }) (map (host: host.wg) (lib.filter (host: host ? wg)
            (lib.attrValues (removeAttrs hosts [ name ]))));
        };
      };

      networking.extraHosts = lib.concatStringsSep "\n" (lib.attrValues
        (lib.mapAttrs
          (name: { wg ? { ip = "0.0.0.0"; }, ... }: "${wg.ip} ${name}.wg")
          hosts));
    })
  ]);
}
