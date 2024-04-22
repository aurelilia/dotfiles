{ ... }:
let
  url = "sync.elia.garden";
in
{
  elia.caddy.routes."${url}".redir = "firefox.feline.works";
}
