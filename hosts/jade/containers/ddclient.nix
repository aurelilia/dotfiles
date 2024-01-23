{ ... }:
let
  mkDdclient = (name: {
    mounts."/etc/ddclient.conf".hostPath = "/containers/ddclient/" + name
      + ".conf";
    config = { ... }: {
      services.ddclient = {
        enable = true;
        configFile = "/etc/ddclient.conf";
      };
    };
  });
in {
  elia.containers.ddclient-garden = mkDdclient "garden";
  elia.containers.ddclient-louane = mkDdclient "louane";
}
