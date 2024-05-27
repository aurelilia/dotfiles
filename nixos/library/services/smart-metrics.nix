{
  lib,
  name,
  config,
  ...
}:
{
  config.services.scrutiny.collector = lib.mkIf config.feline.smartd.enable {
    enable = true;
    schedule = "daily";
    settings.options = {
      host.id = name;
      api.endpoint = "http://haze:53042";
    };
  };

  options.feline.smartd.enable = lib.mkEnableOption "smartd monitoring with Scrutiny";
}
