{
  name,
  lib,
  config,
  ...
}:
let
  cfg = config.feline.dns;
in
{
  config = {
    networking.domains = {
      enable = cfg.enable;
      baseDomains = {
        "elia.garden" = cfg.baseRecord;
        "kitten.works" = cfg.baseRecord;
        "feline.works" = cfg.baseRecord;
        "theria.nl" = cfg.baseRecord;
        "tessa.dog" = cfg.baseRecord;
        "louane.xyz" = cfg.baseRecord;
        "ehir.art" = cfg.baseRecord;
        "catin.eu" = cfg.baseRecord;
      };
    };
  };

  options.feline.dns = {
    enable = lib.mkEnableOption "Declarative DNS records";

    baseRecord = lib.mkOption {
      type = lib.types.attrs;
      default.cname.data = "${name}.elia.garden";
      description = "Base records of this host.";
    };
  };
}
