{...}:
{
  imports = [ ../../../fleet/modules/caddy.nix ];

  config = {
    networking.firewall.allowedTCPPorts = [ 8448 ];
    virtualisation.oci-containers.containers.caddy.ports = [ "8448" ];
    environment.etc."caddy/Caddyfile".text = ''
      import snippets

      # Static public pages
      elia.garden {
        header /.well-known/matrix/* Access-Control-Allow-Origin "*"
        respond /.well-known/matrix/client `{"m.homeserver":{"base_url":"https://matrix.elia.garden/"}}`
        respond /.well-known/matrix/server `{"m.server":"matrix.elia.garden:443"}`

        import no-robots
        root * /srv/html
        file_server
      }

      element.elia.garden, element.louane.xyz {
        import no-robots
        reverse_proxy element-web:80
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

      # Reverse proxies
      git.elia.garden {
        import no-robots
        reverse_proxy gitea:3000
      }

      http://*.elia.garden {
        redir https://{host}{uri}
      }

      # Google telemetry workaround for some networks
      http://connectivitycheck.gstatic.com {
        respond /generate_204 204
      }
    '';
  };
}