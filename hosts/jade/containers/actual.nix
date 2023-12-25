{ ... }:
let caddySnippets = import ../../../fleet/mixins/caddy.nix;
in {
  virtualisation.oci-containers.containers.actual = {
    image = "actualbudget/actual-server:latest-alpine";
    autoStart = true;
    extraOptions = [ "--network=web" ];
    volumes = [ "/containers/actual:/data" ];
  };

  environment.etc."caddy/Caddyfile".text = ''
    actual.elia.garden {
      ${caddySnippets.sso-proxy}
      reverse_proxy actual:5006
    }
  '';
}
