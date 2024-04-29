{ ... }:
{
  feline = {
    borg = {
      persist.time = "05:30";
      media = {
        dirs = [ "/media" ];
        time = "06:30";
      };
    };
    zfs = {
      receive-datasets = [ "zbackup/zend" ];
      znap.enable = true;
      znap.destinations.haze = {
        dataset = "zbackup/zend/haze";
        plan = "1day=>1hour,2week=>1day,2month=>1week,1year=>1month,10year=>3month";
      };
      znap.paths = {
        local = "data/local";
        keep = "data/keep";
      };
    };
  };
}
