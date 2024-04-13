{ ... }:
{
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://ntfy.elia.garden";
      behind-proxy = true;
    };
  };

  elia.caddy.routes."ntfy.elia.garden".port = 2586;
  elia.persist.ntfy.path = "/var/lib/ntfy-sh";
}
