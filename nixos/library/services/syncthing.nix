{ lib, config, ... }:
let
  cfg = config.feline.syncthing;
in
{
  config = lib.mkIf cfg.enable {
    feline.syncthing.devices = {
      haze.id = "BXBEYKL-7HB2FWO-3QCUMCT-THYIAYX-3FAMON3-55VUVLT-77PGNI5-CTSIDQT";
      mauve.id = "HTOI7SH-GCGEHJU-E22T2OV-JRM3QYM-VV7FA4K-35FJMER-A3LLSDX-QTRH7QM";
      bengal.id = "TAVWWH2-RCBPPJQ-RJZSJDR-XBVPDNC-4GJNUTQ-HODQ4LU-KU7HZR5-4SKS4A5";
      hazyboi.id = "RMDWSUF-D2Y2FZZ-JGRYACJ-3RYI3BD-CGYGROU-JWZDW6E-MDKIWQC-ZYTDZQD";
      munchkin.id = "JLWNRZC-B6GLNHT-LIM45JN-GL6ADFF-6YQXPEL-Q4NE34C-HGUBBDO-R4GOGA5";
      hazyboi-windows.id = "YMLCZYR-S2XJ6GM-D2VB6W5-FXLVGFM-UYWB7H7-HN72ODE-VK7HD34-TWQXRA4";
    };

    networking.firewall.allowedTCPPorts = [ 4147 ];
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
            devices = lib.filter (name: name != "munchkin") (lib.attrNames cfg.devices);
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
