{ lib, config, ... }:
let
  cfg = config.elia.persist;
in
{
  config = lib.mkMerge [
    {
      systemd.tmpfiles.rules =
        lib.mapAttrsToList
          (
            name: rule:
            let
              ppath = "/persist/${rule.kind}/${name}";
            in
            "L ${rule.path} - - - - ${ppath}"
          )
          cfg;

      systemd.services.tmp-target-create = {
        description = "Create target directories for temp files";
        after = [ "systemd-tmpfiles-setup.service" ];
        wants = [ "systemd-tmpfiles-setup.service" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig.Type = "oneshot";
        script = lib.concatStringsSep "\n" (
          lib.mapAttrsToList
            (
              name: rule:
              let
                ppath = "/persist/${rule.kind}/${name}";
              in
              ''
                if [ ! -d ${ppath} ]; then
                  mkdir -m ${rule.mode} -p ${ppath}
                  chown ${rule.owner}:${rule.group} ${ppath}
                fi
              ''
            )
            cfg
        );
      };
    }

    (lib.mkIf (config.services.postgresql.enable) {
      elia.persist.postgres = {
        path = "/var/lib/postgresql";
        kind = "data";
        owner = "postgres";
        group = "postgres";
        mode = "700";
      };
    })
    (lib.mkIf (config.services.redis.servers != {}) {
      elia.persist = lib.mapAttrs (name: conf: lib.nameValuePair "redis-${name}" {
        path = "/var/lib/redis-${name}";
        kind = "data";
        owner = "redis";
        group = "redis";
        mode = "700";
      }) config.services.redis.servers;
    })
  ];

  options.elia.persist = lib.mkOption {
    type =
      with lib.types;
      attrsOf (
        submodule (
          { lib, ... }:
          {
            options = {
              path = lib.mkOption {
                type = path;
                description = "Path to symlink into /persist.";
              };
              kind = lib.mkOption {
                type = enum [
                  "data"
                  "config"
                  "secrets"
                ];
                description = ''
                  The kind of information that is being persisted.
                  Changes directory inside /persist, alongside with default permissions.
                '';
                default = "data";
              };

              owner = lib.mkOption {
                type = str;
                description = "Owner of the file or directory.";
                default = "root";
              };
              group = lib.mkOption {
                type = str;
                description = "Group of the file or directory.";
                default = "root";
              };
              mode = lib.mkOption {
                type = str;
                description = "Mode to set the target location to.";
                default = "755";
              };

              isDirectory = lib.mkOption {
                type = bool;
                description = "If the location is a directory.";
                default = true;
              };
            };
          }
        )
      );
    description = "Paths to be persisted.";
    default = { };
  };
}
