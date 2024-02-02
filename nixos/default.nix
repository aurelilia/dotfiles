{ config, lib, ... }:
{
  imports = [ ./library ];

  config = {
    # Locale
    time.timeZone = "Europe/Brussels";
    i18n.defaultLocale = "en_US.UTF-8";

    # Nix(OS) config
    system.stateVersion = "23.11";
    nix = {
      settings = {
        allowed-users = [ "root" ] ++ (lib.optionals (config.elia.systemType == "workstation") [ "leela" ]);
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
      gc = {
        automatic = true;
        options = "--delete-older-than 7d";
      };
    };
    # This does not get set automatically for some reason?
    environment.variables.NIX_REMOTE = "daemon";

    # Misc
    zramSwap.enable = true;
    virtualisation.libvirtd = {
      parallelShutdown = 5;
      qemu.runAsRoot = false;
    };
    boot.supportedFilesystems = [ "ntfs" ];
  };

  options = {
    elia.systemType = lib.mkOption {
      type = lib.types.enum [
        "server"
        "workstation"
      ];
      description = "What type of system to configure.";
    };

    elia.mobile = lib.mkOption {
      type = lib.types.bool;
      description = "If this is a mobile device.";
      default = false;
    };
  };
}
