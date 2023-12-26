{ name, config, lib, pkgs, ... }: {
  virtualisation.libvirtd = {
    enable = true;
    parallelShutdown = 5;
    qemu.runAsRoot = false;
  };
}
