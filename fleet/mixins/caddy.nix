rec {
  no-robots = ''
    respond /robots.txt `User-agent: *
  Disallow: /`
    @not-allowed {
      remote_ip 114.119.0.0/16 # Some weird bot network?
    }
    redir @not-allowed https://www.youtube.com/watch?v=dQw4w9WgXcQ
  '';
  
  sso = "https://sso.elia.garden";
  sso_proxy = ''
    # always forward outpost path to actual outpost
    reverse_proxy /outpost.goauthentik.io/* ${sso}
    # forward authentication to outpost
    @extern not client_ip private_ranges
    forward_auth @extern ${sso} {
        uri /outpost.goauthentik.io/auth/caddy
        copy_headers X-Authentik-Username X-Authentik-Groups X-Authentik-Email X-Authentik-Name X-Authentik-Uid X-Authentik-Jwt X-Authentik-Meta-Jwks X-Authentik-Meta-Outpost X-Authentik-Meta-Provider X-Authentik-Meta-App X-Authentik-Meta-Version
        trusted_proxies 10.0.1.0/16 172.16.0.0/16 fc00::/7
    }
  '';
}
