rec {
  defaultJob = {
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat /run/agenix/borg-repokey";
    };
    environment = { BORG_RSH = "ssh -i /run/agenix/borg-ssh-id"; };
    
    compression = "zstd";
    extraCreateArgs = "--exclude-caches --exclude-if-present .nobackup";

    startAt = "daily";
    persistentTimer = true;

    exclude = [
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
    ];
  };

  systemJob = defaultJob // {
    paths = [
      "/boot"
      "/containers"
      "/etc"
      "/var"
    ];
    exclude = [
      "/etc/ssl"
      "/var/cache"
      "/var/log"
      "/var/db"
    ];

    prune.keep = {
      within = "1d";
      daily = 7;
      weekly = 4;
      monthly = 6;
    };
  };

  systemBorgbase = systemJob // {
    repo = "c689j5a8@c689j5a8.repo.borgbase.com:repo";
  };

  hosts = {
    "c689j5a8.repo.borgbase.com".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMS3185JdDy7ffnr0nLWqVy8FaAQeVh1QYUSiNpW5ESq";
  };
}
