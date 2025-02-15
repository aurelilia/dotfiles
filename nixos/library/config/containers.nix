{ config, lib, ... }:
{
  config.virtualisation.oci-containers.containers = builtins.mapAttrs (name: value: value // ({
    autoStart = true;
  })) config.feline.containers;

  options = {
    feline.containers = lib.mkOption {
      type = lib.types.attrs;
      description = "Containers to run with podman.";
      default = { };
    };
  };
}
