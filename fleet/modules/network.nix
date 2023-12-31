let
  networks = {
    near = {
      gateway = "192.168.0.1";
      prefix = 24;
      nameservers = [ "192.168.0.2" ];
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
      networking.firewall.allowedUDPPorts = [ 50220 ];
      networking.wireguard.interfaces = {
        wg0 = {
          ips = [ "${host.wg.ip}/24" ];
          listenPort = 50220;
          privateKeyFile = "/etc/nixos/wireguard-private";

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
          (name: { wg ? { ip = "0.0.0.0"; }, ... }: "${wg.ip} ${name}-wg")
          hosts));
    })
  ]);
}
