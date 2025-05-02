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
        "tessa.dog" = cfg.baseRecord;
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
