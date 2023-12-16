{...}:
{
  imports = [ ../../../fleet/modules/caddy.nix ];

  config = {
    environment.etc."caddy/Caddyfile".text = ''
      import snippets

      auth.elia.garden {
        reverse_proxy authelia:9091 {
          import trusted_proxy_list
        }
      }

      sync.elia.garden {
        reverse_proxy ffsync:5000
      }

      cloud.elia.garden {
        reverse_proxy nextcloud:80
      }

      matrix.elia.garden {
        reverse_proxy synapse:8008
      }
      matrix.louane.xyz {
        reverse_proxy dendrite:8008
      }

      ci.elia.garden {
        reverse_proxy drone:80
      }

      aur.elia.garden {
        root * /aur
        file_server
      }

      overleaf.elia.garden {
        reverse_proxy overleaf:80
      }

      books.elia.garden {
        reverse_proxy bookstack:80
      }

      music.elia.garden {
        reverse_proxy navidrome:4533
      }

      notify.elia.garden {
          reverse_proxy gotify:80
      }


      # Authenticated pages
      docs.elia.garden {
        import authelia
        reverse_proxy paperless-ng:8000
      }

      actual.elia.garden {
        import authelia
        reverse_proxy actual:5006
      }

      homeassistant.elia.garden {
        import authelia
        reverse_proxy homeassistant:8123
      }

      sonar.elia.garden {
        import authelia
        reverse_proxy lidarr:8686
      }

      searcher.elia.garden {
        import authelia
        reverse_proxy jackett:9117
      }

      # Fully local pages
      (local-net) {
        @not-allowed {
          not {
            remote_ip 10.0.0.0/8 172.16.0.0/12
          }
        }
        redir @not-allowed https://www.youtube.com/watch?v=dQw4w9WgXcQ
      }

      vaultwarden.elia.garden {
        # Taken from vaultwarden wiki
        import local-net
        reverse_proxy /notifications/hub vaultwarden:3012
        reverse_proxy vaultwarden:80 {
          header_up X-Real-IP {remote_host}
        }
      }

      unifi.elia.garden {
        import local-net
        respond "shut"
      }

      jellyfin.elia.garden {
        import local-net
        reverse_proxy jellyfin:8096
      }

      synct.elia.garden {
        import local-net
        reverse_proxy syncthing:8384
      }

      tube.elia.garden {
        import local-net
        reverse_proxy metube:8081
      }

      ha-code.elia.garden {
        import local-net
        reverse_proxy vscode:8443
      }

      ha-esphome.elia.garden {
        import local-net
        reverse_proxy esphome:6052
      }
    '';
  };
}