{ ... }: {
  services.headscale = {
    enable = true;
    address = "0.0.0.0";
    port = 9813;

    settings = {
      dns_config = {
        domains = [ "elia.garden" ];
        base_domain = "ts.elia.garden";
        server_url = "https://headscale.elia.garden:443";
        private_key_path = /persist/secrets/headscale/private.key;
        noise.private_key_path = /persist/secrets/headscale/noise.key;

      };
    };
  };

  environment.etc."caddy/Caddyfile".text = ''
    headscale.elia.garden {
      ${caddySnippets.no-robots}
      reverse_proxy dockerhost:9813
    }
  '';
}
