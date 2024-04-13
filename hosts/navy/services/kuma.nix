{ ... }:
{
  services.uptime-kuma.enable = true;
  elia.caddy.routes."uptime.elia.garden".port = 3001;
  elia.persist.kuma.path = "/var/lib/uptime-kuma";
}
