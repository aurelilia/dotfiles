{ ... }:
let
  mkMachine = index: {
    cpus = 2;
    ram = 4096;
    disks = [ "/var/lib/libvirt/swarm${toString index}.qcow2" ];
    vncSlot = index;
  };
in
{
  elia.qemu.swarm-1 = mkMachine 1;
  elia.qemu.swarm-2 = mkMachine 2;
  elia.qemu.swarm-3 = mkMachine 3;
}
