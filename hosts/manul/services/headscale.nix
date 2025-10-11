{ pkgs, ... }:
let
  dataDir = "/var/lib/headscale";
in
{
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
      exec ${pkgs.headscale}/bin/headscale serve --config /var/lib/headscale/config.yaml
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

  feline.caddy.routes."headscale.elia.garden" = {
    port = 50013;
    extra = "redir / https://catin.eu/blog/headscale.html";
  };

  # Persist files
  feline.persist.headscale.path = "/var/lib/headscale";
}
