{...}:
let
  snippets = import ../../../fleet/mixins/caddy.nix;
in {
  imports = [ ../../../fleet/modules/caddy.nix ];

  config = {
    networking.firewall.allowedTCPPorts = [ 8448 ];
    virtualisation.oci-containers.containers.caddy.ports = [ "8448" ];

    # Drone CI wants to push some static files
    # TODO Maybe integrate this into Nix better?
    users.users.drone = {
      isNormalUser  = true;
      uid = 1000;
      openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFquR2G8EJUqlunUCoWOhiTaqUmuowWRVeMMJaEJI4OUzlWItD3+lQQw+55NaSPEqiOnGZpA61dlJ79k0pVLbBEAOMynk/ljBD+u+HfKbw2KkZYv8NtYDBevK2bT6jlowoYDF7R7QUgn02t2W46E34wMuDpJuVTjLX98iEtQ64UOyFGCtNPASlo+22XdKX8chZWxCjYtFuhpdcxdlIJ9oYzigQsnh0U8/Fi3k2vTTdemPqqk6VoHw+JtOEq7fp6MJgMkgjpwfgwmuy7cN4UkFu0IqJPO1dUBmfPWV1ddpY70xKoV7/1ZYwqjaRIUORkzUQycekunLTxKipSs04rS16C1+3xQ9TVZQrsoBDmTdFFPeUNpevjBd5TTCocays/poPBbhtAAchhNQHGbCZEyI6FK14TOvfMgiOVA1m5wo3ySCwfR5cdFSa72TlL5QJt6YPLyHZl3k7xPPrR9WRQOtUS7qGj+NxQyOOw3I5uqJF0Vw2Czp2QKDo9FgCCy1tGwk= drone@jade" ];
    };

    # Static public pages are defined here.
    environment.etc."caddy/Caddyfile".text = ''
      elia.garden {
        header /.well-known/matrix/* Access-Control-Allow-Origin "*"
        respond /.well-known/matrix/client `{"m.homeserver":{"base_url":"https://matrix.elia.garden/"}}`
        respond /.well-known/matrix/server `{"m.server":"matrix.elia.garden:443"}`

        ${snippets.no-robots}
        root * /srv/html
        file_server
      }

      gelix.elia.garden {
        root * /srv/gelix
        file_server
      }

      study-notes.elia.garden {
        root * /srv/tud-notes
        file_server
      }

      gamelin.elia.garden {
        root * /srv/gamelin
        file_server
      }

      gg.elia.garden, gamegirl.elia.garden {
        root * /srv/gamegirl
        file_server
      }

      file.elia.garden {
        root * /srv/file
        basicauth /hidden/* {
          aurelia $2a$14$HDTVj/YGiEtAA7nICvlSxeEivE3HryuQ9dnFChHGbXYqnDtFVMMba
        }
        file_server
      }

      browse.elia.garden {
        root * /srv/browse
        file_server browse
      }

      mail.elia.garden {
        respond / "hi!"
      }

      louane.xyz {
        header /.well-known/matrix/* Access-Control-Allow-Origin "*"
        respond /.well-known/matrix/client `{"m.homeserver":{"base_url":"https://matrix.louane.xyz/"}}`
        respond /.well-known/matrix/server `{"m.server":"matrix.louane.xyz:443"}`
      }

      # Google telemetry workaround for some networks
      http://connectivitycheck.gstatic.com {
        respond /generate_204 204
      }
    '';
  };
}