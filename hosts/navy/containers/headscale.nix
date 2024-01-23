{ config, ... }: {
  age.secrets.headscale-oidc = {
    file = ../../../secrets/headscale-oidc.age;
    owner = "headscale";
    group = "headscale";
    path = "/var/lib/headscale/headscale-oidc";
    symlink = false;
  };

  services.headscale = {
    enable = true;
    port = 50013;
    address = "0.0.0.0";
    settings = {
      server_url = "https://headscale.elia.garden:443";
      metrics_listen_addr = "127.0.01:50014";
      grpc_listen_addr = "0.0.0.0:50015";

      dns_config = {
        base_domain = "elia.garden";
        nameservers = [ "9.9.9.9" ];
        magic_dns = true;
      };

      oidc = {
        only_start_if_oidc_is_available = true;
        issuer = "https://sso.elia.garden/application/o/headscale/";
        client_id = "pHFKExpydHGYsBYlETETD1roxWlCFJY2LpDZ7xNa";
        client_secret_path = config.age.secrets.headscale-oidc.path;
        allowed_groups = [ "headscale" ];
        strip_email_domain = false;
      };
    };
  };

  elia.caddy.routes = {
    "headscale.elia.garden".extraConfig = ''
      reverse_proxy localhost:50013
    '';
    # "rpc.headscale.elia.garden".extraConfig = ''
    #   reverse_proxy navy:50015
    # '';
  };

  # Persist files
  systemd.tmpfiles.rules = [
    "L /var/lib/headscale - - - - /persist/data/headscale"
    "L /run/agenix/headscale-oidc - - - - /persist/data/headscale"
  ];
}
