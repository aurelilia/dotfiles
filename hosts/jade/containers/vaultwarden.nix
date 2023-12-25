{ ... }:
let caddySnippets = import ../../../fleet/mixins/caddy.nix;
in {
  virtualisation.oci-containers.containers.actual = {
    image = "vaultwarden/server:latest";
    autoStart = true;
    extraOptions = [ "--network=web" ];
    environment.WEBSOCKET_ENABLED = "true";
    volumes = [ "/containers/vaultwarden:/data" ];
  };

  environment.etc."caddy/Caddyfile".text = ''
    vaultwarden.elia.garden {
      ${caddySnippets.sso-proxy}
      reverse_proxy actual:5006
    }
  '';
}
