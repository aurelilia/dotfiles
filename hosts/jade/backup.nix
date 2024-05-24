{ ... }:

{
  feline = {
    borg = {
      persist.time = "04:30";
      media = {
        dirs = [ "/media/.parent" ];
        time = "03:00";
      };
    };
    zfs = {
      receive-datasets = [ "zbackup/zend" ];
      znap = {
        enable = true;
        pools = [
          "zroot"
          "zdata"
        ];
        destinations.jade = {
          dataset = "zbackup/zend/jade";
        };
      };
    };
  };
}
