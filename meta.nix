let
  haze-swarm = {
    config = "haze-swarm";
    tag = "swarm";
  };
in
{
  nodes = {
    navy = {
      tag = "server";
      ipv4 = "202.61.255.155";
      ipv6 = "2a03:4000:55:f57::1";
    };
    jade.tag = "server";
    haze.tag = "server";

    haze-swarm1 = haze-swarm;
    haze-swarm2 = haze-swarm;
    haze-swarm3 = haze-swarm;

    mauve.tag = "workstation";
    coral.tag = "workstation";
    hazyboi.tag = "workstation";
  };
}
