{ ... }:
{
  feline.qemu.cauldron = {
    cpus = 4;
    ram = 8192;
    disks = [ "/var/lib/libvirt/cauldron.qcow2" ];
    vncSlot = 0;
    mac = "52:54:00:12:34:59";
  };
}
