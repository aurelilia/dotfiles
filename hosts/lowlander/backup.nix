{ ... }:
{
  feline = {
    borg = {
      persist = {
        enable = true;
        time = "04:30";
      };
      media = {
        enable = true;
        dirs = [ "/home" ];
        time = "03:00";
      };
    };
    zfs.znap = {
      enable = true;
      remotes = [ "haze" ];
    };
  };
}
