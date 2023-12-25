{ ... }:
let caddySnippets = import ../../../fleet/mixins/caddy.nix;
in {
  virtualisation.oci-containers.containers.kuma = {
    image = "louislam/uptime-kuma:1";
    autoStart = true;
    extraOptions = [ "--network=web" ];
    volumes = [ "/containers/kuma/:/app/data" ];
  };

  environment.etc."caddy/Caddyfile".text = ''
    uptime.elia.garden {
      ${caddySnippets.no-robots}
      reverse_proxy kuma:3001
    }
  '';
}

