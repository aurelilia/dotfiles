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
    "tessa.dog" = gcore-ns;

    "catin.eu" = {
      "" = {
        ns = gcore-ns."".ns;
        mx.data = {
          exchange = "navy.elia.garden";
          preference = 10;
        };
        txt.data = "v=spf1 a:navy.elia.garden ~all";
      };
      "mail._domainkey".txt.data = "v=DKIM1;k=rsa;p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCpe+XScTCIGElLMIdBuQRYWC+jLoed5Z7AtbautKAblQec2JfYEjs0WFv1NcTXmHGlB9aH8nEjtf0popsGB0t/ywU6LhclZA5jsc6hc1037kfaXRfI/pGwcOHyuJRNu/RWthgP1Ac/EDf2QYzA3NPYpMJuntE9EpbvEMDQwC+adwIDAQAB";
      "_dmarc".txt.data = "v=DMARC1;p=none";
    };
    "ehir.art" = {
      "" = {
        ns = gcore-ns."".ns;
        mx.data = {
          exchange = "navy.elia.garden";
          preference = 10;
        };
        txt.data = "v=spf1 a:navy.elia.garden ~all";
      };
      "mail._domainkey".txt.data = "v=DKIM1;k=rsa;p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDnn77i9ppRLxtgZ2FkrPYF9uIjR0sf8AXoH5br/+T6fSrT8JwSVqhkb9k/HHv9UrdABFNfNFsYZT1fjkdcr58WvpENnKb1YfjBr2kBsNczrHWK9z23tpmRpJeymshpXrmKBczYT/UKptAy+R7fS+W93AR+5yQsDBZfBcWwgTYYvQIDAQAB";
      "_dmarc".txt.data = "v=DMARC1;p=none";
    };
  };
}
