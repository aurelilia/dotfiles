{ ... }: {
  # Actual containers are defined using docker compose, since
  # piped is pretty complex in setup and porting it would have been
  # quite some effort.
  # https://piped-docs.kavin.rocks/docs/self-hosting/#docker-compose-nginx-aio-script
  elia.caddy.extra = ''
    piped.elia.garden, api.piped.elia.garden, proxy.piped.elia.garden {
        reverse_proxy http://navy:13415
    }
  '';
}
