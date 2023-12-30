let
  hosts = {
    navy = {
      key = "8ezeQyYgoWhhTILBoXy7ABSCR87pHbjr+LMCVtcU038=";
      ip = "10.45.0.1";
      endpoint = "202.61.255.155:50220";
    };

    haze = {
      key = "qjYusX9sLoL0IOHi7hdnbAus9WIqa3lplEZMZ9QWkEg=";
      ip = "10.45.0.2";
    };

    mauve = {
      key = "UikEcq+qAfPSfoMM+2FBFFezpr+GMNvySxEa6f+3iDI=";
      ip = "10.45.0.3";
    };

    hazyboi = {
      key = "POmbXmW6t1fCyorK3vCcmiZtrusndPrKzieotwOT02w=";
      ip = "10.45.0.4";
    };
  };
in { name, config, lib, pkgs, ... }: {
  networking.firewall.allowedUDPPorts = [ 50220 ];
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "${(lib.getAttr name hosts).ip}/24" ];
      listenPort = 50220;
      privateKeyFile = "/etc/nixos/wireguard-private";

      peers = map (args@{ key, ip, ... }: {
        publicKey = key;
        allowedIPs = [ "${ip}/32" ];
        endpoint = args.endpoint or null;
        persistentKeepalive =
          (if args.endpoint or null != null then 25 else null);
      }) (lib.attrValues (removeAttrs hosts [ name ]));
    };
  };

  networking.extraHosts = lib.concatStringsSep "\n"
    (lib.attrValues (lib.mapAttrs (name: { ip, ... }: "${ip} ${name}") hosts));
}
