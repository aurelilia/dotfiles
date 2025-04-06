{ config, lib, pkgs, ... }:
{
  config = {
    virtualisation.oci-containers.containers = builtins.mapAttrs (name: value: value // ({
      autoStart = true;
      extraOptions = ["--add-host=host.runc.internal:172.17.0.1"];
    })) config.feline.containers;

    systemd.services = lib.listToAttrs (map (name: {
      name = "podman-network-${name}";
      value = {
        path = [ pkgs.podman ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStop = "podman network rm -f ${name}";
        };
        script = ''
          podman network inspect ${name} || podman network create ${name}
        '';
      };
    }) config.feline.podmanNetworks);
  };

  options = {
    feline.containers = lib.mkOption {
      type = lib.types.attrs;
      description = "Containers to run with podman.";
      default = { };
    };

    feline.podmanNetworks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "A list of networks to create.";
      default = [];
    };
  };
}
