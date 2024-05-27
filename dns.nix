let
  gcore-ns."" = {
    ns.data = [
      "ns1.gcorelabs.net"
      "ns2.gcdn.services"
    ];
  };
in
{
  defaultTTL = 3600;
  zones = {
    "kitten.works" = gcore-ns;
    "feline.works" = gcore-ns // {
      # SMTP2GO
      "em1293230".cname.data = "return.smtp2go.net";
      "s1293230._domainkey".cname.data = "dkim.smtp2go.net";
      "smtplink".cname.data = "track.smtp2go.net";
    };
    "theria.nl" = gcore-ns;
  };
}
