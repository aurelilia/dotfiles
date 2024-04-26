let
  nodes = (import ./meta.nix).nodes;

  cname-base = "elia.garden.";
  haze.cname.data = "haze.${cname-base}";
  jade.cname.data = "jade.${cname-base}";
  navy = {
    a.data = nodes.navy.ipv4;
    aaaa.data = nodes.navy.ipv6;
  };

  gcore-ns = {
    ns.data = [
      "ns1.gcorelabs.net"
      "ns2.gcdn.services"
    ];
  };
in
{
  defaultTTL = 3600;
  zones = {
    "kitten.works" = {
      "" = navy // gcore-ns;
      "photos" = haze;
      "media" = haze;
      "music" = haze;
    };
    "feline.works" = {
      "" = navy // gcore-ns;
      "branding" = navy;
      "forge" = navy;
      "chat" = navy;

      "vault" = haze;
      "home" = haze;
      "todo" = haze;
      "budget" = haze;
      "firefox" = haze;
      "anvil" = haze;

      "auth" = jade;

      # SMTP2GO
      "em1293230".cname.data = "return.smtp2go.net.";
      "s1293230._domainkey".cname.data = "dkim.smtp2go.net.";
      "smtplink".cname.data = "track.smtp2go.net.";
    };
    "theria.nl" = {
      "" = navy // gcore-ns;
      "docs" = haze;
      "smart" = haze;
    };
  };
}
