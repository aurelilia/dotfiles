{ pkgs, config, ... }:
{
  systemd.services.colmena-autodeploy = {
    description = "Automatic Colmena Deploy";

    restartIfChanged = false;
    unitConfig.X-StopOnRemoval = false;
    serviceConfig.Type = "oneshot";

    environment = config.nix.envVars // {
      inherit (config.environment.sessionVariables) NIX_PATH;
      HOME = "/root";
    };

    path = with pkgs; [
      coreutils
      gnutar
      xz.bin
      gzip
      gitMinimal
      config.nix.package.out
      config.programs.ssh.package
      colmena
    ];

    script = ''
      rm -rf /tmp/dotfiles
      git clone https://git.elia.garden/leela/dotfiles.git /tmp/dotfiles
      cd /tmp/dotfiles
      nix flake update
      colmena apply-local
    '';

    startAt = "04:27";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };

  systemd.timers.colmena-autodeploy.timerConfig.Persistent = true;
  elia.notify = [ "colmena-autodeploy" ];
}
