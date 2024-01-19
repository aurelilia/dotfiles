{ config, lib, pkgs, ... }: {
  config = {
    networking.nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "ens3";
      # Lazy IPv6 connectivity for the container
      enableIPv6 = true;
    };

    containers = (lib.listToAttrs (lib.imap (icont:
      { name, value }: {
        name = "${name}";
        value = {
          ephemeral = true;
          autoStart = true;

          privateNetwork = true;
          hostAddress = "192.168.47.1";
          localAddress = "192.168.47.${(toString (icont + 1))}";

          bindMounts = value.mounts or { };
          forwardPorts = value.ports or [ ];

          config = (args:
            (lib.mkMerge [
              (value.config args)
              (({ lib, ... }: {
                nixpkgs.pkgs = pkgs;
                system.stateVersion = "23.11";

                networking = {
                  firewall = {
                    enable = true;
                    allowedTCPPorts =
                      (map (port: port.containerPort or port.hostPort)
                        value.ports or [ ]);
                    allowedUDPPorts =
                      (map (port: port.containerPort or port.hostPort)
                        value.ports or [ ]);
                  };
                  # Use systemd-resolved inside the container
                  # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
                  useHostResolvConf = lib.mkForce false;
                  extraHosts = lib.concatStringsSep "\n"
                    ([ "192.168.47.1 host" ] ++ lib.attrValues (lib.mapAttrs
                      (name: { localAddress, ... }: "${localAddress} ${name}")
                      config.containers));
                };

                services.resolved.enable = true;
              }) args)
            ]));
        };
      }) (lib.attrsToList config.elia.containers)));

    networking.extraHosts = lib.concatStringsSep "\n" (lib.attrValues
      (lib.mapAttrs
        (name: { localAddress, ... }: "${localAddress} ${name}.container")
        config.containers));
  };

  options = {
    elia.containers = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
}
