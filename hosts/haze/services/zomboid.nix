# https://kevincox.ca/2022/12/09/valheim-server-nixos-v2/
# https://pzwiki.net/wiki/Dedicated_server
# Thank you!
# Also, PZ devs: Your code sucks.
{ pkgs, ... }:
let
  steam-app = "380870";
  data = "/persist/data/zomboid";
  app = "/var/lib/steam/app-${steam-app}";
  socket = "${data}/zomboid.control";
in
{
  users.users.zomboid = {
    isSystemUser = true;
    # Zomboid puts save data in the home directory.
    home = "${data}";
    createHome = true;
    homeMode = "750";
    group = "zomboid";
  };
  users.groups.zomboid = { };

  elia.steamcmd = true;
  systemd.services.zomboid = {
    wantedBy = [ "multi-user.target" ];

    # Install the game before launching.
    wants = [ "steam@${steam-app}.service" ];
    after = [ "steam@${steam-app}.service" ];

    serviceConfig = {
      ExecStart = ''/bin/sh -c "${pkgs.steam-run}/bin/steam-run ${app}/start-server.sh <${socket}"'';
      ExecStop = ''/bin/sh -c "echo save > ${socket}; sleep 15; echo quit > ${socket}"'';
      Sockets = "zomboid.socket";
      KillSignal = "SIGCONT";

      Restart = "always";
      User = "zomboid";
      WorkingDirectory = "~";
      StateDirectory = "steam/app-${steam-app}";
      ReadWritePaths = "${data}";

      PrivateMounts = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectHostname = true;
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      LockPersonality = true;
    };
    environment.SteamAppId = steam-app;
  };
  systemd.sockets.zomboid = {
    bindsTo = [ "zomboid.service" ];
    socketConfig = {
      ListenFIFO = socket;
      FileDescriptorName = "control";
      RemoveOnStop = true;
      SocketMode = "660";
      SocketUser = "zomboid";
    };
  };
}
