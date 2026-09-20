{ lib, config, pkgs, ... }:
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
      # Configure oci-containers to use docker.
      backend = "docker";
    };

    systemd.services.update-containers = lib.mkIf (config.feline.docker.enable) {
      description = "Automatic container updates";

      restartIfChanged = false;
      unitConfig.X-StopOnRemoval = false;
      serviceConfig.Type = "oneshot";

      path = with pkgs; [
        coreutils
        docker
      ];

      script = lib.concatStringsSep "\n" (
        [
          # First pull all images
          ''
            IMGS=$(docker ps -a --format="{{.Image}}" | sort -u)
            for image in $IMGS; do
              docker pull "$image" || true
            done
          ''
        ]
        # Restart all compose projects. Abuse the fact that their ExecStart is `compose up`
        ++ map (name: "${config.systemd.services."docker-${name}".serviceConfig.ExecStart} -d") (lib.attrNames config.feline.compose)
        # Restart all regular containers - the systemd services will recreate them
        ++ map (name: "systemctl restart docker-${name}") (lib.attrNames config.feline.containers)
      );

      startAt = "05:00";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };
    feline.notify = [ "update-containers" ];
  };

  options.feline.docker.enable = lib.mkEnableOption "Docker host";
}
