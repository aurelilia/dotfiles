{ ... }:
{
  services.nfs.server.enable = true;
  networking.firewall.allowedTCPPorts = [ 2049 ];
  fileSystems."/run/nfs/media" = {
    device = "/media";
    options = [ "bind" ];
  };
  fileSystems."/run/nfs/media/.parent" = {
    device = "/media/.parent";
    options = [ "bind" ];
  };
  services.nfs.server.exports = ''
    /run/nfs 192.168.0.0/255.0.0.0(rw,async,no_root_squash,fsid=0)
    /run/nfs/media 192.168.0.0/255.0.0.0(rw,async,no_root_squash,crossmnt)
    /run/nfs/media/.parent 192.168.0.0/255.0.0.0(rw,async,no_root_squash,crossmnt)
  '';
}
