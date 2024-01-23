{ config, ... }:
with config.lib.caddy.snippets; {
  # Drone CI wants to push some static files
  # TODO Maybe integrate this into Nix better?
  users.users.drone = {
    isNormalUser = true;
    uid = 1000;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALvsHGreZy32FpsI/XHMjfSksWCkFxFyjL8QQD0Diis root@jade"
    ];
  };

  # Static public pages are defined here.
  elia.caddy.routes = {
    "elia.garden".extraConfig = ''
      header /.well-known/matrix/* Access-Control-Allow-Origin "*"
      respond /.well-known/matrix/client `{"m.homeserver":{"base_url":"https://matrix.elia.garden/"}}`
      respond /.well-known/matrix/server `{"m.server":"matrix.elia.garden:443"}`
      redir /.well-known/webfinger https://social.elia.garden{uri}

      ${no-robots}
      root * /srv/html
      file_server
    '';

    "gelix.elia.garden".extraConfig = ''
      root * /srv/gelix
      file_server
    '';

    "study-notes.elia.garden".extraConfig = ''
      root * /srv/tud-notes
      file_server
    '';

    "gamelin.elia.garden".extraConfig = ''
      root * /srv/gamelin
      file_server
    '';

    "gg.elia.garden" = {
      serverAliases = [ "gamegirl.elia.garden" ];
      extraConfig = ''
        root * /srv/gamegirl
        file_server
      '';
    };

    "file.elia.garden".extraConfig = ''
      root * /srv/file
      basicauth /hidden/* {
        aurelia $2a$14$HDTVj/YGiEtAA7nICvlSxeEivE3HryuQ9dnFChHGbXYqnDtFVMMba
      }
      file_server
    '';

    "browse.elia.garden".extraConfig = ''
      root * /srv/browse
      file_server browse
    '';

    "mail.elia.garden".extraConfig = ''
      respond / "hi!"
    '';

    "louane.xyz".extraConfig = ''
      header /.well-known/matrix/* Access-Control-Allow-Origin "*"
      respond /.well-known/matrix/client `{"m.homeserver":{"base_url":"https://matrix.louane.xyz/"}}`
      respond /.well-known/matrix/server `{"m.server":"matrix.louane.xyz:443"}`
    '';

    # Google telemetry workaround for some networks
    "http://connectivitycheck.gstatic.com".extraConfig = ''
      respond /generate_204 204
    '';
  };
}
