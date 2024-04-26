{ ... }:
{
  feline = {
    borg = {
      persist.time = "18:30";
      media = {
        dirs = [ "/home" ];
        time = "19:00";
      };
    };
    zfs.znap.remotes = [ "haze" ];
  };
}
