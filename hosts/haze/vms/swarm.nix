{ ... }:
let
  mkMachine = index: {
    cpus = 2;
    ram = 4096;
    disks = [ "/var/lib/libvirt/swarm${toString index}.qcow2" ];
    vncSlot = index;
    vncListen = "0.0.0.0";
    mac = "52:54:00:12:34:5${toString index}";
  };
in
{
  feline.qemu = {
    swarm-1 = mkMachine 1;
    swarm-2 = mkMachine 2;
    swarm-3 = mkMachine 3;
  };
}
