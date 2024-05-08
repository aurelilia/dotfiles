{ ... }:
{
  boot.kernelModules = [
    "nfs"
    "nfsd"
  ];

  services.nfs.server = {
    enable = true;
    exports = ''
      /media        *(rw,async,no_subtree_check,crossmnt,no_root_squash)
      /wolf  *(rw,async,no_subtree_check,crossmnt,no_root_squash)
    '';
  };
}
