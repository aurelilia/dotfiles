{ lib, config, ... }:
let
  cfg = config.elia.borg;
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
      "/home/*/.nuget"
      "/home/*/.m2"
      "/home/*/.mozilla"
      "/home/*/.thunderbird"
      "/home/*/.config/chromium"
      "/home/*/.config/yarn"
      "/home/*/.config/Code - OSS"
      "/home/*/.config/JetBrains"
      "/home/*/.vscode-oss"
      "/home/*/.var"
      "/home/*/download"
      "/home/*/downloads"
      "/home/*/Download"
      "/home/*/Downloads"

      ## Git
      # Misc dirs
      "build"
      "target"
      "gradle"
      "node_modules"

      # Misc files
      "*.ignore"
    ];
  };
in
{
  config = lib.mkMerge [
    (lib.mkIf (cfg.persist) {
      services.borgbackup.jobs.persist = job // {
        repo = "c689j5a8@c689j5a8.repo.borgbase.com:repo";
        paths = [ "/persist" ];
      };
      elia.notify = [ "borgbackup-job-persist" ];
    })
    (lib.mkIf (cfg.media != [ ]) {
      services.borgbackup.jobs.media = job // {
        paths = cfg.media;
        repo = "c689j5a8@c689j5a8.repo.borgbase.com:repo";
        startAt = "03:00";
      };
      elia.notify = [ "borgbackup-job-media" ];
    })
    (lib.mkIf (config.services.borgbackup.jobs != { }) {
      # Borg secrets
      age.secrets.borg-repokey.file = ../../secrets/borg-repokey.age;
      age.secrets.borg-ssh-id.file = ../../secrets/borg-ssh-id.age;
      # Hosts
      programs.ssh.knownHosts = {
        "c689j5a8.repo.borgbase.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMS3185JdDy7ffnr0nLWqVy8FaAQeVh1QYUSiNpW5ESq";
      };
    })
  ];

  options.elia.borg = {
    persist = lib.mkOption {
      type = lib.types.bool;
      description = "Enable backup of /persist to BorgBase.";
      default = true;
    };

    media = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      description = "Media directories to backup to BorgBase.";
      default = [ ];
    };
  };
}
