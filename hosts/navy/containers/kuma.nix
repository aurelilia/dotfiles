{ config, lib, ... }:
{
  elia.containers.kuma = {
    mounts."/var/lib/private/uptime-kuma" = {
      hostPath = "/containers/kuma";
      isReadOnly = false;
    };

    config =
      { ... }:
      {
        networking.firewall.allowedTCPPorts = [ 3001 ];
        services.uptime-kuma = {
          enable = true;
          appriseSupport = true;
          settings.HOST = "0.0.0.0";
        };
      };
  };

  elia.caddy.routes."uptime.elia.garden" = {
    no-robots = true;
    host = "kuma:3001";
  };
}
