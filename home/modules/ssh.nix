{ config, pkgs, ... }: {
  programs.ssh = {
    enable = true;
    compression = true;

    matchBlocks = {
      jade.user = "root";
      helio.user = "root";
      haze.user = "root";
      navy = {
        user = "root";
        port = 9022;
      };
    };
  };
}
