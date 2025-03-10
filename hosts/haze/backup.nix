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
      receive-datasets = [ "ziggurat/zend" ];
      znap.enable = true;
      znap.destinations.haze = {
        dataset = "ziggurat/zend/haze";
        plan = "1day=>4hour,2week=>1day,2month=>1week,1year=>1month,10year=>3month";
      };
      znap.paths = {
        local = "data/local";
        keep = "data/keep";
      };
    };
  };
}
