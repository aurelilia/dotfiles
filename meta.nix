let
  haze-swarm = {
    config = "haze-swarm";
    tags = [ "virtual" ];
  };
in
{
  nodes = {
    navy = {
      tags = [
        "defaults"
        "server"
        "virtual"
        "prometheus"
      ];
      extra-exporters = [ 59423 ];
      ipv4 = "202.61.255.155";
      ipv6 = "2a03:4000:55:f57::1";
    };
    lowlander.tags = [ ];
    haze = {
      tags = [
        "defaults"
        "server"
        "docker"
        "prometheus"
      ];
      extra-exporters = [ 59423 ];
    };

    haze-swarm1 = haze-swarm;
    haze-swarm2 = haze-swarm;
    haze-swarm3 = haze-swarm;

    mauve.tags = [
      "defaults"
      "workstation"
      "mobile"
    ];
    bengal.tags = [
      "defaults"
      "workstation"
      "mobile"
    ];
    mainecoon.tags = [
      "defaults"
      "workstation"
      "mobile"
    ];
    hazyboi.tags = [
      "defaults"
      "workstation"
    ];
  };
}
