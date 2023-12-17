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
      "/etc"
      "/var"
      "/root"
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
      monthly = 3;
    };
  };

  mediaWorkstationJob = defaultJob // {
    paths = [ "home" ];
    exclude = [
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
      "startpage/repos"

      # cbuild
      "cbuild_cache"
      "bldroot"

      # Vun
      "llvm-project"
      "rust-sources/.git"
      "rust-sources/tests"
      "rust-sources/install"
      "rust-sources.orig/.git"
      "rust-sources.orig/tests"

      # Misc files
      "*.ignore"
      "/oldold"
    ];
  };

  borgbaseMediaUrl = "t5z1y940@t5z1y940.repo.borgbase.com:repo";
  borgbaseSystemUrl = "c689j5a8@c689j5a8.repo.borgbase.com:repo";

  systemBorgbase = systemJob // {
    repo = borgbaseSystemUrl;
  };

  mediaWorkstationBorgbase = mediaWorkstationJob // {
    repo = borgbaseMediaUrl;
    prune.keep = {
      within = "1d";
      daily = 7;
    };
  };

  hosts = {
    "c689j5a8.repo.borgbase.com".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMS3185JdDy7ffnr0nLWqVy8FaAQeVh1QYUSiNpW5ESq";
    "t5z1y940.repo.borgbase.com".publicKey = 
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMS3185JdDy7ffnr0nLWqVy8FaAQeVh1QYUSiNpW5ESq";
  };
}
