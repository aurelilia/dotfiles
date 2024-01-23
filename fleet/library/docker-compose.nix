{ config, lib, pkgs, ... }: {
  config = {
    systemd.services = lib.pipe config.elia.compose [
      lib.attrsToList
      (map ({ name, value }:
        let
          config = (pkgs.writeText (name + ".yml") value.compose);
          env =
            (if ((value.env or null) == null) then "" else ("--env-file" + value.env));
        in {
          name = "docker-" + name;
          value = {
            serviceConfig = {
              ExecStart =
                "${pkgs.docker}/bin/docker compose -p ${name} ${env} -f ${config} up";
              ExecStop = "${pkgs.docker}/bin/docker compose -f ${config} down";
            };
            wantedBy = [ "multi-user.target" ];
            after = [ "docker.service" "docker.socket" ];
          };
        }))
      lib.listToAttrs
    ];
  };

  options = {
    elia.compose = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
}
