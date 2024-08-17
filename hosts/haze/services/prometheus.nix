{ config, lib, ... }:
let
  hosts = lib.attrsets.filterAttrs (
    n: x: lib.any (x: x == "prometheus") x.tags
  ) (import ../../../meta.nix).nodes;
in
{
  services.prometheus = {
    enable = true;
    port = 9701;

    scrapeConfigs = lib.attrValues (
      lib.mapAttrs (
        host:
        {
          extra-exporters ? [ ],
          ...
        }:
        let
          exports = [ config.services.prometheus.exporters.node.port ] ++ extra-exporters;
        in
        {
          job_name = host;
          static_configs = lib.map (port: { targets = [ "${host}:${toString port}" ]; }) exports;
        }
      ) hosts
    );
  };

  feline.persist.prometheus.path = "/var/lib/private/${config.services.prometheus.stateDir}";
}
