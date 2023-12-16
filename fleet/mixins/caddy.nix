rec {
  no-robots = ''
    respond /robots.txt `User-agent: *
  Disallow: /`
    @not-allowed {
      remote_ip 114.119.0.0/16 # Some weird bot network?
    }
    redir @not-allowed https://www.youtube.com/watch?v=dQw4w9WgXcQ
  '';
  
  trusted_proxy_list = "trusted_proxies 10.0.1.0/16 172.16.0.0/16 fc00::/7";
  
  authelia = ''
    forward_auth authelia:9091 {
      uri /api/verify?rd=https://auth.elia.garden/
      copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
      ${trusted_proxy_list}
    }
  '';
}