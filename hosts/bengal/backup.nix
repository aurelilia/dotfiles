{ ... }:
{
  feline = {
    borg = {
      persist.time = "17:30";
      media = {
        dirs = [ "/home" ];
        time = "18:00";
      };
    };
    zfs.znap.remotes = [ "haze" ];
  };
}
