{ ... }:
let caddyDir = "/containers/caddy/";
in {
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  virtualisation.oci-containers.containers.caddy = {
    image = "caddy:2";
    autoStart = true;
    extraOptions = [ "--network=web" ];

    ports = [ "80:80" "443:443" ];
    volumes = [
      "${caddyDir}/srv:/srv:ro"
      "/etc/caddy/Caddyfile:/etc/caddy/Caddyfile:ro"
      "${caddyDir}/data:/data"
    ];
  };

  environment.etc."caddy/Caddyfile".text = ''
    http://*.elia.garden {
      redir https://{host}{uri}
    }
  '';
}
