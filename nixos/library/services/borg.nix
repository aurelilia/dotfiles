{ lib, config, ... }:
let
  cfg = config.feline.borg;
  job = {
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat /run/agenix/borg-repokey";
    };
    environment = {
      BORG_RSH = "ssh -i /run/agenix/borg-ssh-id";
    };

    compression = "zstd";
    extraCreateArgs = "--exclude-caches --exclude-if-present .nobackup";

    startAt = "daily";
    persistentTimer = true;

    prune.keep = {
      within = "1d";
      daily = 7;
    };

    exclude = [
      # Misc files
      "*.pyc"
      "*.dylib"
      "*.rlib"
      "*.a"
      "*.o"
      "*.so"
      "'**/build'"
      "'**/node_modules'"
      "'**/target'"
      "'**/rust-sources/build'"
      "'**/.git'"
      "cache"
      "Cache"
      ".cache"

      # Home
      "/home/*/.thumbnails"
      "/home/*/.cache"
      "/home/*/.local/share/Trash"
      "/home/*/.local/share/PrismLauncher"
      "/home/*/.local/share/JetBrains"
      "/home/*/.local/share/flatpak"
      "/home/*/.local/share/Steam"
      "/home/*/.local/share/umu"
      "/home/*/.local/share/zed/node"
      "/home/*/.local/share/dolphin-emu"
      "/home/*/.nuget"
      "/home/*/.m2"
      "/home/*/.mozilla"
      "/home/*/.thunderbird"
      "/home/*/.config/chromium"
      "/home/*/.config/yarn"
      "/home/*/.config/Code - OSS"
      "/home/*/.config/VSCodium"
      "/home/*/.config/JetBrains"
      "/home/*/.config/feishin"
      "/home/*/.vscode-oss"
      "/home/*/.var"
      "/home/*/.cargo"
      "/home/*/.rustup"
      "/home/*/.npm"
      "/home/*/.gradle"
      "/home/*/download"
      "/home/*/downloads"
      "/home/*/Download"
      "/home/*/Downloads"

      # Backed up by haze
      "/home/*/git"
      "/home/*/personal"

      ## Git
      # Misc dirs
      "build"
      "target"
      "gradle"
      "node_modules"

      # Misc files
      "*.ignore"
      "kuma.db" # uptime-kuma
      "classification_model.pickle" # paperless
    ];
  };

  serviceCfg = {
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "300";
    };
    unitConfig = {
      StartLimitInterval = "3600";
      StartLimitBurst = 3;
    };
  };
in
{
  config = lib.mkMerge [
    (lib.mkIf (cfg.persist.enable) {
      services.borgbackup.jobs.persist = job // {
        paths = [ "/persist" ];
        repo = "c689j5a8@c689j5a8.repo.borgbase.com:repo";
        startAt = cfg.persist.time;
      };
      feline.notify = [ "borgbackup-job-persist" ];
      systemd.services.borgbackup-job-persist = serviceCfg;
    })
    (lib.mkIf (cfg.media.enable) {
      services.borgbackup.jobs.media = job // {
        paths = cfg.media.dirs;
        repo = "c689j5a8@c689j5a8.repo.borgbase.com:repo";
        startAt = cfg.media.time;
      };
      feline.notify = [ "borgbackup-job-media" ];
      systemd.services.borgbackup-job-media = serviceCfg;
    })
    (lib.mkIf (config.services.borgbackup.jobs != { }) {
      # Borg secrets
      age.secrets.borg-repokey.file = ../../../secrets/borg-repokey.age;
      age.secrets.borg-ssh-id.file = ../../../secrets/borg-ssh-id.age;
      # Hosts
      programs.ssh.knownHosts = {
        "c689j5a8.repo.borgbase.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMS3185JdDy7ffnr0nLWqVy8FaAQeVh1QYUSiNpW5ESq";
      };
    })
  ];

  options.feline.borg = {
    persist = {
      enable = lib.mkEnableOption "backup of /persist to BorgBase.";
      time = lib.mkOption {
        type = lib.types.str;
        description = "Time of backup of /persist to BorgBase.";
      };
    };

    media = {
      enable = lib.mkEnableOption "backup of media to BorgBase.";

      dirs = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Media directories to backup to BorgBase.";
        default = [ ];
      };

      time = lib.mkOption {
        type = lib.types.str;
        description = "Time of backup of media directories to BorgBase.";
      };
    };
  };
}
