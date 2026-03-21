{
  lib,
  config,
  name,
  ...
}:
{
  config = {
    systemd.services =
      (lib.listToAttrs (
        map (name: {
          inherit name;
          value.onFailure = [ "ntfy-notify@${name}.service" ];
        }) config.feline.notify
      ))
      // {
        "ntfy-notify@" = {
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${config.lib.pkgs.ntfy-notify} '[${name}] systemd unit %i experienced a failure!' SYSTEMD";
          };
        };
      };
  };

  options.feline.notify = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    description = "List of services to notify on failure for.";
    default = [ ];
  };
}
