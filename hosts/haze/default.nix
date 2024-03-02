{ ... }:
{
  imports = [
    ./backup.nix
    ./hardware.nix
    ./containers/jellyfin.nix
    ./services/adguard.nix
    ./services/guacamole.nix
    ./vms/cauldron.nix
    ./vms/k3s.nix
  ];
  elia.systemType = "server";

  # Initrd networking kernel drivers
  boot.kernelModules = [ "igb" ];
  boot.initrd.kernelModules = [ "igb" ];
  boot.initrd.network.udhcpc.enable = false;
  boot.kernelParams = [ "ip=192.168.0.100" ];

  # QEMU
  networking.bridges.vmbr0.interfaces = [ "eno1" ];
  networking.firewall.enable = false; # uhhh? TODO

  # NFS
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /media          *(rw,fsid=0,async,no_subtree_check,crossmnt,no_root_squash)
  '';
}
