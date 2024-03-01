{ ... }:

{
  elia = {
    borg = {
      persist.time = "04:30";
      media = {
        dirs = [
          "/containers"
          "/media"
        ];
        time = "03:00";
      };
    };
    zfs = {
      receive-datasets = [ "zbackup/zend" ];
      znap.pools = [
        "zroot"
        "zdata"
      ];
      znap.destinations.jade = {
        dataset = "zbackup/zend/jade";
      };
    };
  };
}
