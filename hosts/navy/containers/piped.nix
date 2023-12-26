{ ... }:
let caddySnippets = import ../../../fleet/mixins/caddy.nix;
in {
  virtualisation.oci-containers.containers = {
    # Actual containers are defined using docker compose, since
    # piped is pretty complex in setup and porting it would have been
    # quite some effort.
    # https://piped-docs.kavin.rocks/docs/self-hosting/#docker-compose-nginx-aio-script
  };

  environment.etc."caddy/Caddyfile".text = ''
    piped.elia.garden, api.piped.elia.garden, proxy.piped.elia.garden {
        reverse_proxy http://piped-nginx:80
    }
  '';
}