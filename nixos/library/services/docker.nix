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
      daemon.settings = lib.mkIf config.feline.docker.metrics-enable { metrics-addr = "0.0.0.0:59423"; };
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

  options.feline.docker = {
    enable = lib.mkEnableOption "Docker host";
    metrics-enable = lib.mkOption {
      type = lib.types.bool;
      default = config.feline.prometheus.enable;
      description = "Enable docker metrics";
    };
  };
}
