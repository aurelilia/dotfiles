{ config, lib, ... }:
let
  cfg = config.elia.caddy;
  no-robots = ''
      respond /robots.txt `User-agent: *
    Disallow: /`
      @not-allowed {
        remote_ip 114.119.0.0/16 # Some weird bot network?
      }
      redir @not-allowed https://www.youtube.com/watch?v=dQw4w9WgXcQ
  '';
  sso = ''
    # always forward outpost path to actual outpost
    reverse_proxy /outpost.goauthentik.io/* ${cfg.sso}
    # forward authentication to outpost
    @extern not client_ip private_ranges
    forward_auth @extern ${cfg.sso} {
        uri /outpost.goauthentik.io/auth/caddy
        copy_headers X-Authentik-Username X-Authentik-Groups X-Authentik-Email X-Authentik-Name X-Authentik-Uid X-Authentik-Jwt X-Authentik-Meta-Jwks X-Authentik-Meta-Outpost X-Authentik-Meta-Provider X-Authentik-Meta-App X-Authentik-Meta-Version
        trusted_proxies 10.0.1.0/16 172.16.0.0/16 fc00::/7
    }
  '';
  local = ''
    @not-allowed {
        not {
            remote_ip 10.0.0.0/8 192.168.0.0/16 172.16.0.0/12
        }
    }
    redir @not-allowed https://www.youtube.com/watch?v=dQw4w9WgXcQ
  '';
in
{
  config = lib.mkIf (cfg.routes != { }) {
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
    networking.firewall.allowedUDPPorts = [ 443 ];

    services.caddy = {
      enable = true;
      extraConfig = cfg.extra;
      virtualHosts = (
        lib.mapAttrs
          (name: route: {
            serverAliases = route.aliases;
            extraConfig = lib.concatStringsSep "\n" (
              [ route.extra ]
              ++ lib.optionals route.no-robots [ no-robots ]
              ++ lib.optionals (route.mode == "sso") [ sso ]
              ++ lib.optionals (route.mode == "local") [ local ]
              ++ lib.optionals (route.host != null) [ "reverse_proxy ${route.host}" ]
              ++ lib.optionals (route.port != null) [ "reverse_proxy localhost:${toString route.port}" ]
              ++ lib.optionals (route.root != null) [
                "root * ${route.root}"
                "file_server"
              ]
            );
          })
          cfg.routes
      );
    };

    # Hardening, based on:
    # https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/services/web-servers/nginx/default.nix
    # https://github.com/caddyserver/dist/pull/79
    systemd.services.caddy.serviceConfig = {
      # Static file access
      ReadOnlyPaths =
        cfg.readDirs
        ++ lib.filter (x: x != null) (lib.mapAttrsToList (route: { root, ... }: root) cfg.routes);
      # Proc filesystem
      ProtectProc = "invisible";
      # Capabilities
      AmbientCapabilities = [
        "CAP_NET_BIND_SERVICE"
        "CAP_SYS_RESOURCE"
      ];
      CapabilityBoundingSet = [
        "CAP_NET_BIND_SERVICE"
        "CAP_SYS_RESOURCE"
      ];
      # Security
      NoNewPrivileges = true;
      # Sandboxing (sorted by occurrence in https://www.freedesktop.org/software/systemd/man/systemd.exec.html)
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectHostname = true;
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RemoveIPC = true;
    };

    elia.persist.caddy = {
      path = "/var/lib/caddy";
      owner = "caddy";
      group = "caddy";
    };
    elia.notify = [ "caddy" ];
  };

  options.elia.caddy = {
    extra = lib.mkOption {
      type = lib.types.lines;
      description = "Extra configuration to add to the generated Caddyfile.";
      default = "";
    };

    readDirs = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      description = "Additional paths to give the Caddy server RO access to.";
      default = [ ];
    };

    routes = lib.mkOption {
      type =
        with lib.types;
        attrsOf (
          submodule (
            { lib, ... }:
            {
              options = {
                root = lib.mkOption {
                  type = nullOr path;
                  description = "Root path for a file server.";
                  default = null;
                };
                host = lib.mkOption {
                  type = nullOr str;
                  description = "Host to reverse proxy.";
                  default = null;
                };
                port = lib.mkOption {
                  type = nullOr int;
                  description = "Port on local host to reverse proxy.";
                  default = null;
                };
                mode = lib.mkOption {
                  type = enum [
                    "public"
                    "sso"
                    "local"
                  ];
                  description = "Mode to run the route with.";
                  default = "public";
                };
                no-robots = lib.mkOption {
                  type = bool;
                  description = "Disable robots.";
                  default = false;
                };
                aliases = lib.mkOption {
                  type = listOf str;
                  default = [ ];
                  description = "Additional places to serve the route at.";
                };
                extra = lib.mkOption {
                  type = lines;
                  default = "";
                  description = "Additional configuration to add to the host.";
                };
              };
            }
          )
        );
      description = "Routes to be served.";
      default = { };
    };

    sso = lib.mkOption {
      type = lib.types.str;
      description = "Host for Authentik SSO.";
      default = "https://sso.elia.garden";
    };
  };
}
