{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.feline.caddy;
  cfgMonitorRoutes = lib.filterAttrs (
    n: v: v.redir == null && v.root == null && v.monitoringEnable
  ) cfg.routes;
  no-robots = ''
      respond /robots.txt `User-agent: *
    Disallow: /`
      @not-allowed {
        remote_ip 114.119.0.0/16 # Some weird bot network?
      }
      redir @not-allowed https://www.youtube.com/watch?v=wpV-gGA4PSk
  '';
  sso = ''
    # always forward outpost path to actual outpost
    reverse_proxy /outpost.goauthentik.io/* ${cfg.sso}
    # forward authentication to outpost
    @extern not client_ip private_ranges
    forward_auth @extern ${cfg.sso} {
        uri /outpost.goauthentik.io/auth/caddy
        copy_headers X-Authentik-Username X-Authentik-Groups X-Authentik-Email X-Authentik-Name X-Authentik-Uid X-Authentik-Jwt X-Authentik-Meta-Jwks X-Authentik-Meta-Outpost X-Authentik-Meta-Provider X-Authentik-Meta-App X-Authentik-Meta-Version
        trusted_proxies 10.0.1.0/16 172.16.0.0/16 fc00::/7 100.64.0.0/16
    }
  '';
  local = ''
    @not-allowed-local {
        not {
            remote_ip 10.0.0.0/8 192.168.0.0/16 172.16.0.0/12 100.64.0.0/16
        }
    }
    redir @not-allowed-local https://www.youtube.com/watch?v=wpV-gGA4PSk
  '';
  tailnet = ''
    @not-allowed-tailnet {
        not {
            remote_ip 100.64.0.0/16
        }
    }
    redir @not-allowed-tailnet https://www.youtube.com/watch?v=wpV-gGA4PSk
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
        lib.mapAttrs (name: route: {
          serverAliases = route.aliases;
          extraConfig = lib.concatStringsSep "\n" (
            [ route.extra ]
            ++ lib.optionals route.no-robots [ no-robots ]
            ++ lib.optionals (route.mode == "sso") [ sso ]
            ++ lib.optionals (route.mode == "local") [ local ]
            ++ lib.optionals (route.mode == "tailnet") [ tailnet ]
            ++ lib.optionals (route.host != null) [ "reverse_proxy ${route.host}" ]
            ++ lib.optionals (route.redir != null) [ "redir https://${route.redir}{uri}" ]
            ++ lib.optionals (route.port != null) [ "reverse_proxy localhost:${toString route.port}" ]
            ++ lib.optionals (route.root != null) [
              "root * ${route.root}"
              "file_server"
            ]
          );
        }) cfg.routes
      );
    };

    # Configure DNS where wanted
    networking.domains.subDomains =
      let
        routes = lib.filterAttrs (name: route: route.configureDns) cfg.routes;
        routeDns = lib.mapAttrs (name: route: { }) routes;

        aliases = lib.concatLists (lib.mapAttrsToList (name: value: value.aliases) routes);
        aliasDns = lib.listToAttrs (
          map (name: {
            inherit name;
            value = { };
          }) aliases
        );
      in
      routeDns // aliasDns;

    feline.persist.caddy = {
      path = "/var/lib/caddy";
      owner = "caddy";
      group = "caddy";
    };
    feline.notify = [ "caddy" ];

    systemd.services =
      let
        # Service monitoring
        monitoring = lib.mapAttrs' (
          name: value:
          lib.nameValuePair "caddy-monitor-${lib.replaceString "." "-" name}" {
            script = ''
              STATUS=$(${pkgs.curl}/bin/curl -s -o /dev/null -w "%{http_code}" https://${name}/${value.monitoringPath})
              if [ "$STATUS" != ${value.monitoringStatusCode} ]; then
                ${config.lib.pkgs.ntfy-notify} "[${name}] $STATUS was unexpected!" SERVICES
              fi
            '';
            serviceConfig = {
              Type = "oneshot";
              User = "caddy";
            };
          }
        ) cfgMonitorRoutes;

        # Hardening, based on:
        # https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/services/web-servers/nginx/default.nix
        # https://github.com/caddyserver/dist/pull/79
        hardening = {
          caddy.serviceConfig = {
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
        };
      in
      monitoring // hardening;

    systemd.timers = lib.mapAttrs' (
      name: value:
      lib.nameValuePair "caddy-monitor-${lib.replaceString "." "-" name}" {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "hourly";
          Unit = "caddy-monitor-${lib.replaceString "." "-" name}.service";
        };
      }
    ) cfgMonitorRoutes;
  };

  options.feline.caddy = {
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
                    "tailnet"
                  ];
                  description = "Mode to run the route with.";
                  default = "public";
                };
                no-robots = lib.mkOption {
                  type = bool;
                  description = "Disable robots.";
                  default = true;
                };
                aliases = lib.mkOption {
                  type = listOf str;
                  default = [ ];
                  description = "Additional places to serve the route at.";
                };
                redir = lib.mkOption {
                  type = nullOr str;
                  default = null;
                  description = "URL to redirect to.";
                };
                extra = lib.mkOption {
                  type = lines;
                  default = "";
                  description = "Additional configuration to add to the host.";
                };

                configureDns = lib.mkOption {
                  type = bool;
                  default = true;
                  description = "Automatically add a DNS entry for the route.";
                };
                monitoringEnable = lib.mkOption {
                  type = bool;
                  default = true;
                  description = "Enable monitoring of the route.";
                };
                monitoringPath = lib.mkOption {
                  type = str;
                  default = "";
                  description = "URI to try and receive.";
                };
                monitoringStatusCode = lib.mkOption {
                  type = str;
                  default = "200";
                  description = "Expected status code.";
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
      default = "https://auth.catin.eu";
    };
  };
}
