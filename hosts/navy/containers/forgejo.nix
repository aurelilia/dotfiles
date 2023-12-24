{...}:
let
  caddySnippets = import ../../../fleet/mixins/caddy.nix;
in {
  networking.firewall.allowedTCPPorts = [ 22 ];
  virtualisation.oci-containers.containers.forgejo = {
    image = "codeberg.org/forgejo/forgejo:1.21";
    autoStart = true;
    extraOptions = [ "--network=web" ];

    environment = {
      USER_UID = "1000";
      USER_GID = "1000";
    };

    ports = [ "22:22" ];
    volumes = [ 
      "/containers/forgejo/data:/data"
      "/etc/timezone:/etc/timezone:ro"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };

  environment.etc."caddy/Caddyfile".text = ''
    git.elia.garden {
      ${caddySnippets.no-robots}
      reverse_proxy forgejo:3000
    }
  '';
}

