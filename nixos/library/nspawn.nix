margs@{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.elia.containers;
in
{
  # TODO Refactor, probably
  config = lib.mkIf (cfg != { }) {
    networking.nat = {
      enable = true;
      enableIPv6 = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = config.elia.natExternal;
    };

    containers = lib.pipe cfg [
      lib.attrsToList
      (lib.imap (
        icont:
        { name, value }:
        {
          inherit name;
          value = {
            ephemeral = true;
            autoStart = true;

            privateNetwork = true;
            hostAddress = "192.168.47.1";
            localAddress = "192.168.47.${(toString (icont + 1))}";

            bindMounts = value.mounts or { };
            forwardPorts = value.ports or [ ];

            config =
              args@{ lib, ... }:
              lib.mkMerge [
                (value.config args)
                {
                  nixpkgs.pkgs = pkgs;
                  system.stateVersion = "23.11";

                  networking = {
                    hostName = "${margs.name}-${name}";
                    firewall =
                      let
                        ports = (map (port: port.containerPort or port.hostPort) value.ports or [ ]);
                      in
                      {
                        enable = true;
                        allowedTCPPorts = ports;
                        allowedUDPPorts = ports;
                      };
                    # Use systemd-resolved inside the container
                    # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
                    useHostResolvConf = lib.mkForce false;
                    extraHosts = lib.concatStringsSep "\n" (
                      [ "192.168.47.1 host ${margs.name}" ]
                      ++ lib.attrValues (
                        lib.mapAttrs (name: { localAddress, ... }: "${localAddress} ${name}") config.containers
                      )
                    );
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
                }
              ];
          };
        }
      ))
      lib.listToAttrs
    ];

    networking.extraHosts = lib.pipe config.containers [
      (lib.mapAttrsToList (name: { localAddress, ... }: "${localAddress} ${name}.container"))
      (lib.concatStringsSep "\n")
    ];
  };

  options = {
    elia.containers = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
    elia.natExternal = lib.mkOption {
      type = lib.types.str;
      description = "External NAT interface, used by NixOS containers";
      default = "lan";
    };
  };
}
