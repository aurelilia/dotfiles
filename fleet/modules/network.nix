{ name, config, lib, pkgs, ... }: {
  networking = {
    hostName = name;
    fqdn = name + ".elia.garden";
    firewall.enable = true;
    extraHosts = ''
      10.0.1.10 helio
      10.0.0.1 celadon
      10.0.1.1 jade
      202.61.255.155 navy
    '';
  };
}
