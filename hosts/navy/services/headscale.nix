{ pkgs, ... }:
let
  dataDir = "/var/lib/headscale";
in
{
  age.secrets.headscale-config = {
    file = ../../../secrets/navy/headscale-config.age;
    owner = "headscale";
    group = "headscale";
    path = "/etc/headscale/config.yaml";
  };

  # Adapted from the NixOS module:
  # https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/services/networking/headscale.nix
  # Done since headscale just *refuses* to read OIDC secrets from a file...
  environment.systemPackages = [ pkgs.headscale ];
  users.groups.headscale = { };
  users.users.headscale = {
    description = "headscale user";
    home = dataDir;
    group = "headscale";
    isSystemUser = true;
  };

  systemd.services.headscale = {
    description = "headscale coordination server for Tailscale";
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    environment.GIN_MODE = "release";

    script = ''
      exec ${pkgs.headscale}/bin/headscale serve
    '';

    serviceConfig =
      let
        capabilityBoundingSet = [ "CAP_CHOWN" ];
      in
      {
        Restart = "always";
        Type = "simple";
        User = "headscale";
        Group = "headscale";

        # Hardening options
        RuntimeDirectory = "headscale";
        # Allow headscale group access so users can be added and use the CLI.
        RuntimeDirectoryMode = "0750";

        StateDirectory = "headscale";
        StateDirectoryMode = "0750";

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        RestrictSUIDSGID = true;
        PrivateMounts = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        RestrictNamespaces = true;
        RemoveIPC = true;
        UMask = "0077";

        CapabilityBoundingSet = capabilityBoundingSet;
        AmbientCapabilities = capabilityBoundingSet;
        NoNewPrivileges = true;
        LockPersonality = true;
        RestrictRealtime = true;
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "@chown"
        ];
        SystemCallArchitectures = "native";
        RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX";
      };
  };

  elia.caddy.routes."headscale.elia.garden" = {
    port = 50013;
    extra = "redir / https://elia.garden/blog/headscale.html";
  };

  # Persist files
  elia.persist.headscale.path = "/var/lib/headscale";

  # In case the module MIGHT get fixed at some point:
  /*
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
          client_id = "headscale";
          scope = ["openid" "profile" "email"];
          extra_params = {
            domain_hint = "elia.garden";
          };
          client_secret_path = config.age.secrets.headscale-oidc.path;
          allowed_groups = [ "headscale" ];
          strip_email_domain = false;
        };
      };
    };
  */
}
