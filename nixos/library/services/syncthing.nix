{ lib, config, ... }:
let
  cfg = config.feline.syncthing;
in
{
  config = lib.mkIf cfg.enable {
    feline.syncthing.devices = {
      haze.id = "BXBEYKL-7HB2FWO-3QCUMCT-THYIAYX-3FAMON3-55VUVLT-77PGNI5-CTSIDQT";
      mauve.id = "HTOI7SH-GCGEHJU-E22T2OV-JRM3QYM-VV7FA4K-35FJMER-A3LLSDX-QTRH7QM";
    };

    services.syncthing = {
      inherit (cfg) user dataDir configDir;

      enable = true;
      group = cfg.user;
      openDefaultPorts = true;
      guiAddress = "0.0.0.0:4147";

      settings = {
        inherit (cfg) devices;

        folders = {
          git = {
            path = "${cfg.dataDir}/git";
            devices = lib.attrNames cfg.devices;
          };
          personal = {
            path = "${cfg.dataDir}/personal";
            devices = lib.attrNames cfg.devices;
          };
        };

        options = {
          localAnnounceEnabled = true;
          maxFolderConcurrency = 2;
          relaysEnabled = true;
          limitBandwidthInLan = false;
          urAccepted = -1;
        };
      };
    };
  };

  options.feline.syncthing = {
    enable = lib.mkEnableOption "Syncthing";

    user = lib.mkOption {
      type = lib.types.str;
      description = "User to run Syncthing as.";
    };

    devices = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
      description = "Devices to add.";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      description = "Prefix to use for folder paths.";
    };

    configDir = lib.mkOption {
      type = lib.types.str;
      description = "Configuration directory.";
      default = "${cfg.dataDir}/.config/syncthing";
    };
  };
}
