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
          "--schedule"
          "0 0 3 * * *"
        ];
        environment.TZ = "Europe/Berlin";
        autoStart = true;
      };
    };
  };

  options.feline.docker.enable = lib.mkEnableOption "Docker host";
}
