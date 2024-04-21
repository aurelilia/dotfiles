{ ... }:
{
  services.nfs.server = {
    enable = true;
    exports = ''
      /run/nfs        *(rw,fsid=0,async,no_subtree_check,crossmnt,no_root_squash)
      /run/nfs/media  *(rw,fsid=0,async,no_subtree_check,crossmnt,no_root_squash)
      /run/nfs/wolf   *(rw,fsid=0,async,no_subtree_check,crossmnt,no_root_squash)
    '';
  };

  fileSystems."/run/nfs/media" = {
    device = "/media";
    options = [ "bind" ];
  };
  fileSystems."/run/nfs/wolf" = {
    device = "/wolf";
    options = [ "bind" ];
  };
}
