{ ... }:
let
  root = "/persist/data/caddy/srv";
  mkMatrixWellKnown = (
    name: ''
      header /.well-known/matrix/* Access-Control-Allow-Origin "*"
      respond /.well-known/matrix/client `{"m.homeserver":{"base_url":"https://matrix.${name}/"}}`
      respond /.well-known/matrix/server `{"m.server":"matrix.${name}:443"}`
    ''
  );
in
{
  # Drone CI wants to push some static files
  users.users.drone = {
    isNormalUser = true;
    uid = 1000;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALvsHGreZy32FpsI/XHMjfSksWCkFxFyjL8QQD0Diis root@jade"
    ];
  };

  # Static public pages are defined here.
  elia.caddy.readDirs = [ "${root}/browse" ];
  elia.caddy.routes = {
    "elia.garden" = {
      root = "${root}/html";
      extra =
        (mkMatrixWellKnown "elia.garden")
        + "\n"
        + "redir /.well-known/webfinger https://social.elia.garden{uri}";
    };

    "gamelin.elia.garden".root = "${root}/gamelin";
    "gg.elia.garden" = {
      aliases = [ "gamegirl.elia.garden" ];
      root = "${root}/gamegirl";
    };

    "file.elia.garden" = {
      root = "${root}/file";
      extra = ''
        basicauth /hidden/* {
          aurelia $2a$14$HDTVj/YGiEtAA7nICvlSxeEivE3HryuQ9dnFChHGbXYqnDtFVMMba
        }
      '';
    };

    "browse.elia.garden".extra = ''
      root * ${root}/browse
      file_server browse
    '';

    "louane.xyz".extra = (mkMatrixWellKnown "louane.xyz");

    # Google telemetry workaround for some networks
    "http://connectivitycheck.gstatic.com".extra = "respond /generate_204 204";
  };
}
