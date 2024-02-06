{
  config,
  lib,
  pkgs,
  ...
}:
let
  transform =
    { services, volumes }:
    {
      version = "3";
      inherit volumes;
      services =
        builtins.mapAttrs
          (
            name: value:
            value
            // {
              container_name = name;
              restart = "unless-stopped";
            }
          )
          services;
    };
in
{
  config = lib.mkIf (config.elia.compose != { }) {
    virtualisation.docker.enable = true;
    systemd.services = lib.pipe config.elia.compose [
      lib.attrsToList
      (map (
        { name, value }:
        let
          config = pkgs.writeText (name + ".yml") (builtins.toJSON (transform value.compose));
          env = (if (value.env == null) then "" else "--env-file=${value.env}");
        in
        {
          name = "docker-${name}";
          value = {
            serviceConfig = {
              ExecStart = "${pkgs.docker}/bin/docker compose -p ${name} ${env} -f ${config} up";
              ExecStop = "${pkgs.docker}/bin/docker compose -f ${config} down";
            };
            wantedBy = [ "multi-user.target" ];
            after = [
              "docker.service"
              "docker.socket"
            ];
          };
        }
      ))
      lib.listToAttrs
    ];
  };

  options = {
    elia.compose = lib.mkOption {
      type =
        with lib.types;
        attrsOf (
          submodule (
            { lib, ... }:
            {
              options = {
                env = lib.mkOption {
                  type = nullOr str;
                  description = "Environment file for the compose file.";
                  default = null;
                };
                compose = lib.mkOption {
                  type = attrs;
                  description = "Actual compose file.";
                  default = { };
                };
              };
            }
          )
        );
      description = "Docker Compose projects to run.";
      default = { };
    };
  };
}
