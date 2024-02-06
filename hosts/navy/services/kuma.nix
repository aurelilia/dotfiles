{ ... }:
{
  services.uptime-kuma = {
    enable = true;
    appriseSupport = true;
  };

  elia.caddy.routes."uptime.elia.garden" = {
    no-robots = true;
    port = 3001;
  };

  elia.persist.kuma.path = "/var/lib/private/uptime-kuma";
}
