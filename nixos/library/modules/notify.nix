{
  lib,
  config,
  name,
  ...
}:
{
  config = {
    age.secrets.matrix-notify.file = ../../secrets/matrix-notify.age;
    systemd.services =
      (lib.listToAttrs (
        map (name: {
          inherit name;
          value.onFailure = [ "matrix-notify@${name}.service" ];
        }) config.elia.notify
      ))
      // {
        "matrix-notify@" = {
          serviceConfig = {
            EnvironmentFile = "${config.age.secrets.matrix-notify.path}";
            Type = "oneshot";
            ExecStart = "${config.lib.pkgs.matrix-notify} '[${name}] systemd unit %i experienced a failure!'";
          };
        };
      };
  };

  options.elia.notify = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    description = "List of services to notify on failure for.";
    default = [ ];
  };
}
