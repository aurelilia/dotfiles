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
              ++ lib.optionals (route.root != null) [
                "root * ${route.root}"
                "file_server"
              ]
            );
          })
          cfg.routes
      );
      dataDir = "/containers/caddy/data";
    };

    # Hardening, based on:
    # https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/services/web-servers/nginx/default.nix
    systemd.services.caddy.serviceConfig = {
      # Proc
      ProcSubset = "pid";
      ProtectProc = "invisible";
      # New file permissions
      UMask = "0027"; # 0640 / 0750
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
      RestrictAddressFamilies = [
        "AF_UNIX"
        "AF_INET"
        "AF_INET6"
      ];
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RemoveIPC = true;
      PrivateMounts = true;
      # System Call Filtering
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "~@cpu-emulation @debug @keyring @mount @obsolete @privileged @setuid" ];
    };

    fileSystems."/containers/caddy/srv" = {
      device = "/persist/caddy/srv";
      options = [ "bind" ];
    };
  };

  options.elia.caddy = {
    extra = lib.mkOption {
      type = lib.types.lines;
      default = ''
        http://*.elia.garden {
          redir https://{host}{uri}
        }
      '';
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
