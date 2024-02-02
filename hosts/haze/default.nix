{ ... }:
{
  imports = [
    ./backup.nix
    ./hardware.nix
    ./containers/jellyfin.nix
    ./containers/pihole.nix
  ];
  elia.systemType = "server";

  # Initrd networking kernel drivers
  boot.kernelModules = [ "igb" ];
  boot.initrd.kernelModules = [ "igb" ];
  boot.initrd.network.udhcpc.enable = false;
  boot.kernelParams = [ "ip=192.168.0.100" ];

  # Libvirt
  networking.bridges.vmbr0.interfaces = [ "eno1" ];
  networking.firewall.enable = false; # uhhh? TODO
  virtualisation.libvirtd.enable = true;

  # NFS
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /media          *(rw,fsid=0,async,no_subtree_check,crossmnt,no_root_squash)
  '';

  # Wanted for hypervisor access
  services.tailscale.enable = true;
}
