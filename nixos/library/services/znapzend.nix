{
  lib,
  config,
  name,
  ...
}:
let
  cfg = config.feline.zfs.znap;
in
{
  config = lib.mkIf cfg.enable {
    programs.ssh.knownHosts = (import ../../../secrets/keys.nix).zfs-receiver;
    services.znapzend = {
      enable = true;
      autoCreation = true;
      pure = true;
      mailErrorSummaryTo = "znap@elia.garden";

      features = {
        compressed = true;
        sendRaw = true;
        zfsGetType = true;
        skipIntermediates = true;
      };

      zetup = (
        lib.concatMapAttrs
          (pool: value: {
            "${pool}-keep" = value // {
              dataset = "${pool}/${cfg.paths.keep}";
              plan = "1day=>1hour,2week=>1day,2month=>1week,1year=>1month,10year=>3month";
              destinations =
                cfg.destinations
                // (lib.genAttrs cfg.remotes (remote: {
                  host = "zend@${remote}";
                  dataset = "ziggurat/zend/${name}";
                  plan = "1day=>4hour,2week=>1day,2month=>1week,1year=>1month,10year=>3month";
                }));
            };
            "${pool}-local" = value // {
              dataset = "${pool}/${cfg.paths.local}";
              plan = "1day=>1hour,2week=>1day";
            };
          })
          (
            lib.genAttrs cfg.pools (pool: {
              recursive = true;
            })
          )
      );
    };

    systemd.services.znapzend.after = [ "tailscaled.service" ];
    feline.notify = [ "znapzend" ];
  };

  options.feline.zfs.znap = {
    enable = lib.mkEnableOption "ZnapZend Backups";

    pools = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Pools to back up.";
      default = [ "zroot" ];
    };

    paths = {
      keep = lib.mkOption {
        type = lib.types.str;
        description = "Path of the 'keep' dataset in the pools.";
        default = "keep";
      };
      local = lib.mkOption {
        type = lib.types.str;
        description = "Path of the 'local' dataset in the pools.";
        default = "local";
      };
    };

    remotes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Known remotes to back up to.";
      default = [ ];
    };

    destinations = lib.mkOption {
      type = lib.types.attrs;
      description = "Additional destinations to back up to.";
      default = { };
    };
  };
}
