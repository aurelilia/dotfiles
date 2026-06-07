{
  pkgs,
  config,
  lib,
  name,
  ...
}:
let
  cfg = config.feline.autodeploy;
  nixos-rebuild = ''${config.system.build.nixos-rebuild}/bin/nixos-rebuild --flake ".#${name}"'';
in
{
  config = lib.mkIf (cfg.local or (cfg.remotes != [ ])) {
    systemd.services.nixos-autodeploy = {
      description = "Automatic NixOS Deploy";

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
      ];

      script = lib.concatStringsSep "\n" (
        [
          ''
            rm -rf /tmp/dotfiles
            git clone https://forge.catin.eu/leela/dotfiles.git /tmp/dotfiles
            cd /tmp/dotfiles

            cp flake.lock flake.lock.old
            nix flake update
            if diff flake.lock flake.lock.old ; then
              echo "Nothing to update. Exiting!"
              exit 0
            fi
          ''
        ]
        ++ (lib.optional (cfg.local && !cfg.noSwitch) ''
          CURRENT="$(readlink -f /run/current-system/bin/switch-to-configuration)"
          if ${nixos-rebuild} switch ; then
            echo "Deployed!"
            exit 0
          fi

          echo "Deploy failed, switching back to previous"
          $CURRENT switch
          exit 1
        '')
        ++ (lib.optional (cfg.local && cfg.noSwitch) ''
          ${nixos-rebuild} boot
        '')
      );

      startAt = cfg.time;
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };

    systemd.timers.nixos-autodeploy.timerConfig.Persistent = true;
    feline.notify = [ "nixos-autodeploy" ];
  };

  options.feline.autodeploy = {
    local = lib.mkEnableOption "Automatically deploying the current configuration locally";
    time = lib.mkOption {
      type = lib.types.str;
      description = "Time of the day to deploy the configuration.";
      default = "04:27";
    };
    noSwitch = lib.mkEnableOption "Don't switch to configuration immediately";
  };
}
