{ lib, pkgs, ... }:
# Based on https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/services/networking/ddclient.nix
# Cannot use it directly since jade has to run multiple ddclient configurations
let
  mkService = (config:
    let
      dataDir = "/var/lib/ddclient-${config}";
      StateDirectory = builtins.baseNameOf dataDir;
      RuntimeDirectory = StateDirectory;
      preStart = ''
        install --mode=600 --owner=$USER /persist/data/ddclient-${config}.conf /run/${RuntimeDirectory}/ddclient.conf
      '';
    in {
      description = "Dynamic DNS Client";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        DynamicUser = true;
        RuntimeDirectoryMode = "0700";
        inherit RuntimeDirectory;
        inherit StateDirectory;
        Type = "oneshot";
        ExecStartPre = "!${pkgs.writeShellScript "ddclient-prestart" preStart}";
        ExecStart = "${
            lib.getExe pkgs.ddclient
          } -file /run/${RuntimeDirectory}/ddclient.conf";
      };
    });
  timer = {
    description = "Run ddclient";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "10min";
      OnUnitInactiveSec = "10min";
    };
  };
in {
  systemd.services = {
    ddclient-garden = mkService "garden";
    ddclient-louane = mkService "louane";
  };
  systemd.timers = {
    ddclient-garden = timer;
    ddclient-louane = timer;
  };
}
