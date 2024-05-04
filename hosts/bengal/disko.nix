{
  disko.devices = {
    disk = {
      m2 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            swap = {
              size = "42G";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          ashift = "12";
          acltype = "posixacl";
          relatime = "on";
          xattr = "sa";
          dnodesize = "auto";
          normalization = "formD";
          canmount = "off";

          compression = "zstd";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "file:///tmp/secret.key";
        };
        postCreateHook = ''
          zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank
          zfs set keylocation="prompt" zroot
        '';

        datasets = {
          "system/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
          };
          "system/store" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "legacy";
          };

          "local/ethereal" = {
            type = "zfs_fs";
            options.mountpoint = "/ethereal";
          };
          "local/flatpak" = {
            type = "zfs_fs";
            options.mountpoint = "/home/leela/.var";
          };
          "local/opt" = {
            type = "zfs_fs";
            options.mountpoint = "/opt";
          };

          "keep/home" = {
            type = "zfs_fs";
            options.mountpoint = "/home";
          };
          "keep/persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options.mountpoint = "legacy";
          };
        };
      };
    };
  };
}
