{ config, lib, pkgs, ... }: {
  virtualisation.docker = {
    enable = true;
    listenOptions = [ "/run/docker.sock" ];
    autoPrune = {
      enable = true;
      flags = [ "--all" ];
    };
  };

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
