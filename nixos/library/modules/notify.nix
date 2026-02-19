{
  lib,
  config,
  name,
  ...
}:
{
  config = {
    age.secrets.matrix-notify.file = ../../../secrets/matrix-notify.age;
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
            EnvironmentFile = "${config.age.secrets.matrix-notify.path}";
            Type = "oneshot";
            ExecStart = "${config.lib.pkgs.ntfy-notify} '[${name}] systemd unit %i experienced a failure!'";
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
