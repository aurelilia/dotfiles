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
    };
    "feline.works" = {
      "" = navy // gcore-ns;
      "vault" = haze;
      "home" = haze;
      "id" = haze;
      "todo" = haze;
    };
    "theria.nl" = {
      "" = navy // gcore-ns;
    };
  };
}
