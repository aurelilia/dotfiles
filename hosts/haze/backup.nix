{ ... }:
{
  elia = {
    borg.media = [
      "/containers"
      "/media"
    ];
    zfs.znap = {
      remotes = [ "jade" ];
      paths = {
        local = "data/local";
        keep = "data/keep";
      };
    };
  };
}
