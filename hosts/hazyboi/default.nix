args@{ config, lib, pkgs, ... }: {
    ./backup.nix
    ./hardware.nix

    ../../fleet/modules/borg.nix
    ../../fleet/modules/wireguard.nix
    ../../fleet/modules/zfs.nix
  ];

  networking.hostId = "00000000";
}
