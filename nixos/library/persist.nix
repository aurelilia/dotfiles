{ lib, config, ... }:
let
  cfg = config.elia.persist;
in
{
  config = {
    systemd.tmpfiles.rules = lib.mapAttrsToList
        (
          name: rule:
          let
            ppath = "/persist/${rule.kind}/${name}";
          in
          ''
            L ${rule.path} - - - - ${ppath}
            ${if rule.isDirectory then "D" else "F"} ${ppath} ${toString rule.mode} ${rule.owner} ${rule.group}
          ''
        )
        cfg;
  };

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
                type = int;
                description = "Mode to set the target location to.";
                default = 755;
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
