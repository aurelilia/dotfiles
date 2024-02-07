{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = {
    environment.etc."qemu/bridge.conf".text = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: value: "allow ${value.bridge}") config.elia.qemu
    );

    systemd.services = lib.pipe config.elia.qemu [
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
              "-cpu host"
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
            ++ (lib.optionals (value.vnc != null) [ "-display vnc=127.0.0.1:${toString value.vnc}" ])
            ++ value.extraQemuArgs
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

  options.elia.qemu = lib.mkOption {
    type =
      with lib.types;
      attrsOf (
        submodule (
          { lib, ... }:
          {
            options = {
              cpus = lib.mkOption {
                type = int;
                description = "The amount of virtual CPU cores to allocate the machine.";
                default = 2;
              };
              ram = lib.mkOption {
                type = int;
                description = "The amount of RAM to give the machine, in megabytes.";
                default = 2048;
              };
              disks = lib.mkOption {
                type = listOf path;
                description = "Disks to attach to the VM.";
                default = [ ];
              };
              vnc = lib.mkOption {
                type = nullOr int;
                description = "VNC port index to use. Will open on port 5900 + X.";
                default = null;
              };
              bridge = lib.mkOption {
                type = str;
                description = "The network device (bridge) to attach to the VM.";
                default = "vmbr0";
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
