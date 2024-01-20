{ config, lib, pkgs, ... }: {
  virtualisation.docker = {
    enable = true;
    listenOptions = [ "/run/docker.sock" ];
    autoPrune = {
      enable = true;
      flags = [ "--all" ];
    };
  };

  # Create a 'web' network; all docker hosts use this anyway
  system.activationScripts.dockernet.text = ''
    ${pkgs.docker}/bin/docker network create -d bridge web || true
  '';

  virtualisation.oci-containers = {
    backend = "docker";

    containers.watchtower = {
      image = "containrrr/watchtower";
      volumes = [ "/run/docker.sock:/var/run/docker.sock" ];
      cmd = [ "--interval" "7200" ];
      autoStart = true;
    };
  };
}
