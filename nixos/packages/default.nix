{ pkgs, config, ... }:
{
  imports = [ ./paperless.nix ];
  config = {
    age.secrets.matrix-notify.file = ../../secrets/matrix-notify.age;

    lib.pkgs = {
      postgres-upgrade =
        { new, old }:
        (pkgs.writeScriptBin "pg-upgrade-${old.psqlSchema}-to-${new.psqlSchema}" ''
          set -eux
          systemctl stop postgresql

          export NEWDATA="/var/lib/postgresql/${new.psqlSchema}"
          export NEWBIN="${new}/bin"

          export OLDDATA="/var/lib/postgresql/${old.psqlSchema}"
          export OLDBIN="${old}/bin"

          install -d -m 0700 -o postgres -g postgres "$NEWDATA"
          cd "$NEWDATA"
          sudo -u postgres $NEWBIN/initdb -D "$NEWDATA"

          sudo -u postgres $NEWBIN/pg_upgrade \
            --old-datadir "$OLDDATA" --new-datadir "$NEWDATA" \
            --old-bindir $OLDBIN --new-bindir $NEWBIN \
            "$@"
        '');

      ntfy-notify = pkgs.writeShellScript "ntfy-notify-service" ''
        #!/run/current-system/sw/bin/bash
        source ${config.age.secrets.matrix-notify.path}
        ${pkgs.curl}/bin/curl -d "$1" \
          https://ntfy.catin.eu/''${!2}
      '';
    };
  };
}
