{ lib, config, ... }:
{
  virtualisation.docker = {
    listenOptions = [ "/run/docker.sock" ];
    logDriver = "journald";
    autoPrune = {
      enable = true;
      flags = [ "--all" ];
    };
  };

  virtualisation.oci-containers = lib.mkIf (config.elia.systemType == "server") {
    # If we're on a server: Configure oci-containers to use docker and
    # add watchtower for automatic updates
    backend = "docker";
    containers.watchtower = {
      image = "containrrr/watchtower";
      volumes = [ "/run/docker.sock:/var/run/docker.sock" ];
      cmd = [
        "--interval"
        "7200"
      ];
      autoStart = true;
    };
  };
}
