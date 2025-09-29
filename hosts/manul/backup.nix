{ ... }:
{
  feline = {
    borg = {
      persist = {
        enable = true;
        time = "04:30";
      };
      media.enable = false;
    };
    zfs.znap = {
      enable = true;
      remotes = [ "haze" ];
    };
  };
}
