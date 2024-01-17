{ config, lib, pkgs, ... }: {
  config = {
    lib.containers = {};

    networking.nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "ens3";
      # Lazy IPv6 connectivity for the container
      enableIPv6 = true;
    };

    containers = (lib.foldl (a: b: a // b) {} (map lib.listToAttrs 
      (lib.imap (inet: network: 
        (lib.imap (icont: { name, value }: {
          name = "${name}-${network.name}";
          value = {
            ephemeral = true;
            autoStart = true;

            privateNetwork = true;
            hostAddress = "192.168.${(toString (inet + 10))}.1";
            localAddress = "192.168.${(toString (inet + 10))}.${(toString (icont + 1))}";

            bindMounts = value.mounts or {};
            forwardPorts = value.ports or [];

            config = (args: (lib.mkMerge [
              (value.config args)
              (({ lib, ... }: {
                nixpkgs.pkgs = pkgs;
                system.stateVersion = "23.11";

                networking = {
                  firewall.enable = true;
                  # Use systemd-resolved inside the container
                  # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
                  useHostResolvConf = lib.mkForce false;
                  extraHosts = lib.concatStringsSep "\n" (lib.attrValues
                    (lib.mapAttrs
                      (name: { localAddress, ... }: "${localAddress} ${name}")
                      config.containers));
                };

                services.resolved.enable = true;
              }) args)
            ]));
          };
        }) (lib.attrsToList network.value))
      ) (lib.attrsToList config.lib.containers))
    ));

    networking.extraHosts = lib.concatStringsSep "\n" (lib.attrValues
      (lib.mapAttrs
        (name: { localAddress, ... }: "${localAddress} ${name}.container")
        config.containers));
  };
}
