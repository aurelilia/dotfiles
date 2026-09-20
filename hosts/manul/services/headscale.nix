{ pkgs, ... }: {
  # Headscale
  services.headscale = {
    enable = true;
    port = 50013;
    address = "0.0.0.0";
    settings = {
      server_url = "https://mesh.catin.eu:443";
      dns = {
        base_domain = "feline.systems";
        override_local_dns = false;
        magic_dns = true;
        nameservers.global = [ "9.9.9.9" ];
      };
      policy.mode = "database";
    };
  };
  feline.persist.headscale.path = "/var/lib/headscale";

  # Headplane
  services.headplane = {
    enable = true;
    settings.server = {
      base_url = "https://meshplane.catin.eu";
      data_path = "/persist/data/headplane";
      port = 50017;
      cookie_secret_path = "/persist/data/headplane/cookie";
    };
  };

  # Routes!
  feline.caddy.routes = {
    "mesh.catin.eu" = {
      aliases = [ "headscale.elia.garden" ];
      port = 50013;
      extra = "redir / https://catin.eu/blog/headscale.html";
      monitoringEnable = true;
      monitoringPath = "test";
      monitoringStatusCode = "404";
    };
    "meshplane.catin.eu".port = 50017;
  };
}
