{ pkgs, ... }:
{
  imports = [ ./paperless.nix ];
  config.lib.pkgs = {
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

    matrix-notify = pkgs.writeShellScript "matrix-notify-service" ''
      #!/run/current-system/sw/bin/bash
      ${pkgs.curl}/bin/curl -X PUT -H "Authorization: Bearer $ACCESS_TOKEN" \
        --data "{\"msgtype\":\"m.text\",\"body\":\"$1\"}" \
        https://matrix.elia.garden/_matrix/client/r0/rooms/$ROOM/send/m.room.message/$RANDOM$RANDOM$RANDOM$RANDOM 
    '';
  };
}
