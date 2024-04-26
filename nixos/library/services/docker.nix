{ lib, config, ... }:
{
  config = {
    virtualisation.docker = {
      listenOptions = [ "/run/docker.sock" ];
      logDriver = "journald";
      autoPrune = {
        enable = true;
        flags = [ "--all" ];
      };
    };

    virtualisation.oci-containers = lib.mkIf (config.feline.docker.enable) {
      # Configure oci-containers to use docker and add watchtower for automatic updates
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
  };

  options.feline.docker.enable = lib.mkEnableOption "Docker host";
}
