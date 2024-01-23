let
  conf = rec {
    networks = {
      near = {
        gateway = "192.168.0.1";
        prefix = 24;
        nameservers = [ "192.168.0.100" ];
      };

      far = {
        gateway = "10.0.0.1";
        prefix = 16;
        nameservers = [ "10.0.1.10" ];
      };
    };

    hosts = {
      haze = networks.near // {
        mac = "3c:ec:ef:ea:f4:67";
        address = "192.168.0.100";

        wg = {
          key = "qjYusX9sLoL0IOHi7hdnbAus9WIqa3lplEZMZ9QWkEg=";
          ip = "10.45.0.2";
        };
      };

      hazyboi = networks.near // {
        mac = "f4:b5:20:50:ef:55";
        address = "192.168.0.10";

        wg = {
          key = "POmbXmW6t1fCyorK3vCcmiZtrusndPrKzieotwOT02w=";
          ip = "10.45.0.4";
        };
      };

      jade = networks.far // {
        mac = "94:de:80:21:d2:08";
        address = "10.0.1.1";

        wg = {
          key = "U9vjXmnxWiHEdeDQM53K4hE23XZTdgBqoI4gxXKGlik=";
          ip = "10.45.0.5";
        };
      };

      mauve = {
        # This is a mobile device using WLAN, static IPv4 configuration
        # does not make sense since it is often in foreign networks.
        # The address in `near` is instead assigned at the DHCP server
        address = "192.168.0.212";

        wg = {
          key = "UikEcq+qAfPSfoMM+2FBFFezpr+GMNvySxEa6f+3iDI=";
          ip = "10.45.0.3";
        };
      };

      navy = {
        address = "202.61.255.155";

        wg = {
          key = "8ezeQyYgoWhhTILBoXy7ABSCR87pHbjr+LMCVtcU038=";
          ip = "10.45.0.1";
          endpoint = "202.61.255.155:50220";
        };
      };

      celadon.address = "10.0.0.1";
    };
  };
in { name, lib, pkgs, config, ... }:
let
  networks = conf.networks;
  hosts = conf.hosts;
  host = (lib.getAttr name hosts);
in {
  config = (lib.mkMerge [
    # General config
    {
      lib.network = conf;
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
        nameservers = host.nameservers ++ [ "9.9.9.9" ];
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
      age.secrets."wg-gossip".file = ../../secrets/wg-gossip.age;

      networking.firewall = {
        allowedUDPPorts = [ 50220 ];
        trustedInterfaces = [ "wg0" ];
      };

      networking.wireguard.interfaces.wg0 = {
        ips = [ "${host.wg.ip}/24" ];
        listenPort = 50220;
        privateKeyFile = "/persist/secrets/wireguard/wireguard-private";
        mtu = 1400;
      };

      services.wgautomesh = {
        enable = true;
        gossipSecretFile = config.age.secrets.wg-gossip.path;

        settings = {
          interface = "wg0";
          peers = map (args@{ key, ip, ... }: {
            pubkey = key;
            address = ip;
            endpoint = args.endpoint or null;
          }) (map (host: host.wg) (lib.filter (host: host ? wg)
            (lib.attrValues (removeAttrs hosts [ name ]))));
        };
      };

      networking.extraHosts = lib.concatStringsSep "\n" (lib.attrValues
        (lib.mapAttrs
          (name: { wg ? { ip = "0.0.0.0"; }, ... }: "${wg.ip} ${name}") hosts));
    })
  ]);
}
