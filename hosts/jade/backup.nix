{ ... }:

{
  elia = {
    borg.media = [
      "/containers"
      "/media"
    ];
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
