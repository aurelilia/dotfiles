{
  config,
  lib,
  pkgs,
  ...
}:
let
  transform =
    args@{ services, ... }:
    args
    // {
      version = "3";
      services = builtins.mapAttrs (
        name: value:
        (
          {
            container_name = name;
            restart = "unless-stopped";
          }
          // value
        )
      ) services;
    };
in
{
  config = lib.mkIf (config.feline.compose != { }) {
    virtualisation.docker.enable = true;
    systemd.services = lib.mapAttrs' (
      name: value:
      let
        config = pkgs.writeText (name + ".yml") (builtins.toJSON ((transform value) // { inherit name; }));
      in
      lib.nameValuePair "docker-${name}" {
        serviceConfig = {
          ExecStart = "${pkgs.docker}/bin/docker compose -p ${name} -f ${config} up";
          ExecStop = "${pkgs.docker}/bin/docker compose -f ${config} down";
        };
        wantedBy = [ "multi-user.target" ];
        after = [
          "docker.service"
          "docker.socket"
        ];
      }
    ) config.feline.compose;
  };

  options.feline.compose = lib.mkOption {
    type = lib.types.attrs;
    description = "Docker Compose projects to run, defined using DC project files.";
    default = { };
  };
}
