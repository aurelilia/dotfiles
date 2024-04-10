{ ... }:
{
  services.ddclient = {
    enable = true;
    configFile = "/persist/data/ddclient-garden.conf";
  };
}
