{
  config,
  pkgs,
  ...
}:
{
  systemd.services.build-homepage = {
    description = "Build catin.eu";

    restartIfChanged = false;
    unitConfig.X-StopOnRemoval = false;
    serviceConfig.Type = "oneshot";

    path = with pkgs; [
      coreutils
      gitMinimal
      config.nix.package.out
    ];

    script = ''
      git clone https://forge.catin.eu/leela/startpage.git /persist/data/caddy/homepage-repo || true
      cd /persist/data/caddy/homepage-repo
      git pull origin HEAD
      nix develop -c python build.py
      cp -r *.html css font blog ../srv/html/
    '';

    startAt = "02:00";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };

  systemd.timers.build-homepage.timerConfig.Persistent = true;
  feline.notify = [ "build-homepage" ];
}
