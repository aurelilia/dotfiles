{ config, lib, ... }: {
  config = lib.mkIf (config.elia.caddy.routes != { }) (lib.mkMerge [
    {
      networking.firewall.allowedTCPPorts = [ 80 443 ];
      lib.caddy.snippets = {
        no-robots = ''
            respond /robots.txt `User-agent: *
          Disallow: /`
            @not-allowed {
              remote_ip 114.119.0.0/16 # Some weird bot network?
            }
            redir @not-allowed https://www.youtube.com/watch?v=dQw4w9WgXcQ
        '';

        sso-proxy = ''
          # always forward outpost path to actual outpost
          reverse_proxy /outpost.goauthentik.io/* ${config.lib.sso-host}
          # forward authentication to outpost
          @extern not client_ip private_ranges
          forward_auth @extern ${config.lib.sso-host} {
              uri /outpost.goauthentik.io/auth/caddy
              copy_headers X-Authentik-Username X-Authentik-Groups X-Authentik-Email X-Authentik-Name X-Authentik-Uid X-Authentik-Jwt X-Authentik-Meta-Jwks X-Authentik-Meta-Outpost X-Authentik-Meta-Provider X-Authentik-Meta-App X-Authentik-Meta-Version
              trusted_proxies 10.0.1.0/16 172.16.0.0/16 fc00::/7
          }
        '';

        local-net = ''
          @not-allowed {
              not {
                  remote_ip 10.0.0.0/8 172.16.0.0/12
              }
          }
          redir @not-allowed https://www.youtube.com/watch?v=dQw4w9WgXcQ
        '';
      };
    }
    (lib.mkIf (config.elia.caddy.bare) {
      services.caddy = {
        enable = true;
        extraConfig = config.elia.caddy.extra;
        virtualHosts = config.elia.caddy.routes;
        dataDir = "/containers/caddy/data";
      };

      fileSystems."/srv/caddy" = {
        device = "/containers/caddy/srv";
        options = [ "bind" ];
      };
    })
    (lib.mkIf (!config.elia.caddy.bare) {
      elia.containers.caddy = {
        mounts."/srv" = {
          hostPath = "/containers/caddy/srv";
          isReadOnly = true;
        };
        mounts."/var/lib/caddy" = {
          hostPath = "/containers/caddy/data";
          isReadOnly = false;
        };

        ports = [ { hostPort = 80; } { hostPort = 443; } ];

        config = { ... }: {
          services.caddy = {
            enable = true;
            extraConfig = config.elia.caddy.extra;
            virtualHosts = config.elia.caddy.routes;
          };
        };
      };
    })
  ]);

  options = {
    elia.caddy = {
      extra = lib.mkOption {
        type = lib.types.lines;
        default = ''
          http://*.elia.garden {
            redir https://{host}{uri}
          }
        '';
      };
      routes = lib.mkOption {
        type = lib.types.attrs;
        default = { };
      };
      bare = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };
}
