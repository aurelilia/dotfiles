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
              size = "18G";
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
        options.ashift = "12";
        rootFsOptions = {
          acltype = "posixacl";
          relatime = "on";
          xattr = "sa";
          dnodesize = "auto";
          normalization = "formD";
          canmount = "off";
          compression = "zstd";
        };
        postCreateHook = ''
          zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank
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
