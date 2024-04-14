{ ... }:
let url = "id.feline.works"; port = 53124; tls_chain = "/persist/data/kanidm/chain.pem";
in
{
  services.kanidm = {
    enableServer = true;
    serverSettings = {
      origin = "https://${url}";
      domain = "feline.works";
      bindaddress = "[::1]:${toString port}";
      inherit tls_chain;
      tls_key = "/persist/data/kanidm/key.pem";
    };
  };

  elia.caddy.routes.${url}.extra = ''
    reverse_proxy https://localhost:${toString port} {
      header_up Host {upstream_hostport}
      transport http {
        tls_trusted_ca_certs ${tls_chain}
        tls_server_name ${url}
      }
    }
  '';
  elia.persist."kanidm".path = "/var/lib/kanidm";
}
