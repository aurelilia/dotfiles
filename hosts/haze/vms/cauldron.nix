{ ... }:
{
  elia.qemu.cauldron = {
    cpus = 4;
    ram = 8192;
    disks = [ "/var/lib/libvirt/cauldron.qcow2" ];
    vncSlot = 0;
  };
}
