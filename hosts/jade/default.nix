{ config, lib, pkgs, ... }: {
  imports = [ ./backup.nix ./hardware.nix ./services/tvheadend.nix ];

  # Caddy, for now, until it's migrated into a NixOS container
  networking.firewall.allowedTCPPorts = [ 80 443 8448 ];

  # NFS
  services.nfs.server.enable = true;
  fileSystems."/run/nfs/media" = {
    device = "/media";
    options = [ "bind" ];
  };
  services.nfs.server.exports = ''
    /run/nfs 10.0.0.0/255.0.0.0(rw,async,no_root_squash,fsid=0)
    /run/nfs/media 10.0.0.0/255.0.0.0(rw,async,no_root_squash,crossmnt)
  '';
}
