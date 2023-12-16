{...}:
{
  networking.firewall.allowedTCPPorts = [ 22 ];
  virtualisation.oci-containers.containers = {
    caddy.dependsOn = [ "gitea" ];
    
    gitea = {
      image = "gitea/gitea:1";
      autoStart = true;
      extraOptions = [ "--network=web" ];

      environment = {
        USER_UID = "1000";
        USER_GID = "1000";
      };

      ports = [ "22:22" ];
      volumes = [ 
        "/containers/gitea/data:/data"
        "/etc/timezone:/etc/timezone:ro"
        "/etc/localtime:/etc/localtime:ro"
      ];
    };
  };
}

