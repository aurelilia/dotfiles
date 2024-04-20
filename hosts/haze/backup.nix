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
    zfs = {
      receive-datasets = [ "zbackup/zend" ];
      znap.destinations.haze = {
        dataset = "zbackup/zend/haze";
      };
      znap.paths = {
        local = "data/local";
        keep = "data/keep";
      };
    };
  };
}
