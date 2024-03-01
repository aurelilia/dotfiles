{ ... }:
{
  elia = {
    borg = {
      persist.time = "05:30";
      media = {
        dirs = [ "/media" ];
        time = "06:30";
      };
    };
    zfs.znap = {
      remotes = [ "jade" ];
      paths = {
        local = "data/local";
        keep = "data/keep";
      };
    };
  };
}
