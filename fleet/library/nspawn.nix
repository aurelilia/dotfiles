margs@{ config, lib, pkgs, ... }: {
  config = lib.mkIf (config.elia.containers != { }) {
    networking.nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = config.elia.natExternal;
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
                  hostName = "${margs.name}-${name}";
                  firewall = let
                    ports = (map (port: port.containerPort or port.hostPort)
                      value.ports or [ ]);
                  in {
                    enable = true;
                    allowedTCPPorts = ports;
                    allowedUDPPorts = ports;
                  };
                  # Use systemd-resolved inside the container
                  # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
                  useHostResolvConf = lib.mkForce false;
                  extraHosts = lib.concatStringsSep "\n"
                    ([ "192.168.47.1 host ${margs.name}" ] ++ lib.attrValues
                      (lib.mapAttrs
                        (name: { localAddress, ... }: "${localAddress} ${name}")
                        config.containers));
                };
                services.resolved.enable = true;

                # Some useful aliases for working in these minimal containers,
                # and a shell whose defaults aren't garbage
                programs.fish.enable = true;
                users.users.root.shell = pkgs.fish;
                environment.shellAliases = {
                  log = "journalctl -xeu";
                  slog = "journalctl -e";
                  ll = "ls -lh";
                  la = "ls -lha";
                  ctl = "systemctl";
                  ctls = "systemctl status";
                  ctlr = "systemctl restart";
                };
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
    elia.natExternal = lib.mkOption {
      type = lib.types.string;
      default = "lan";
    };
  };
}
