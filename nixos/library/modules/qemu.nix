{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = {
    environment.etc."qemu/bridge.conf".text = lib.concatLines (
      lib.mapAttrsToList (name: value: "allow ${value.bridge}") config.feline.qemu
    );

    systemd.services = lib.pipe config.feline.qemu [
      lib.attrsToList
      (map (
        { name, value }:
        let
          options = lib.concatStringsSep " " (
            [
              # Base stuff
              "-name guest=${name}"
              "-machine q35"
              "--enable-kvm"
              "-cpu ${value.cpuModel}"
              "-smp ${toString value.cpus}"
              "-m ${toString value.ram}"
              "-nic bridge,br=${value.bridge},model=virtio-net-pci"

              # Some things libvirt does that seemed alright
              "-overcommit mem-lock=off"
              "-sandbox on,obsolete=deny,elevateprivileges=deny,resourcecontrol=deny"
              "-msg timestamp=on"
              "-watchdog-action reset"
              "-object rng-random,id=rng0,filename=/dev/urandom -device virtio-rng-pci,rng=rng0"
            ]
            ++ (map (disk: "-drive file=${disk},media=disk,if=virtio") value.disks)
            ++ (map (disk: "-drive file=${disk},media=cdrom") value.cdroms)
            ++ (lib.optional (
              value.vncSlot != null
            ) "-display vnc=${value.vncListen}:${toString value.vncSlot}")
            ++ [ (lib.escapeShellArgs value.extraQemuArgs) ]
          );
        in
        {
          name = "qemu-${name}";
          value = {
            serviceConfig = {
              ExecStart = "${pkgs.qemu}/bin/qemu-system-x86_64 ${options}";
            };
            wantedBy = [ "multi-user.target" ];
          };
        }
      ))
      lib.listToAttrs
    ];
  };

  options.feline.qemu = lib.mkOption {
    type =
      with lib.types;
      attrsOf (
        submodule (
          { lib, ... }:
          {
            options = {
              cpus = lib.mkOption {
                type = ints.u8;
                description = "The amount of virtual CPU cores to allocate the machine.";
                default = 2;
              };
              cpuModel = lib.mkOption {
                type = str;
                description = "CPU model to emulate.";
                default = "host";
              };
              ram = lib.mkOption {
                type = ints.u32;
                description = "The amount of RAM to give the machine, in megabytes.";
                default = 2048;
              };
              bridge = lib.mkOption {
                type = str;
                description = "The network device (bridge) to attach to the VM.";
                default = "vmbr0";
              };

              disks = lib.mkOption {
                type = listOf path;
                description = "Disks to attach to the VM.";
                default = [ ];
              };
              cdroms = lib.mkOption {
                type = listOf path;
                description = "CD-ROM drives to attach to the VM.";
                default = [ ];
              };

              vncSlot = lib.mkOption {
                type = nullOr ints.u16;
                description = "VNC slot to use. Will open on port 5900 + X.";
                default = null;
              };
              vncListen = lib.mkOption {
                type = nullOr str;
                description = "Address for the VNC server to listen on.";
                default = "127.0.0.1";
              };

              extraQemuArgs = lib.mkOption {
                type = listOf str;
                default = [ ];
                description = "Additional arguments to QEMU.";
              };
            };
          }
        )
      );
    description = "Virtual machines to run with QEMU.";
    default = { };
  };
}
