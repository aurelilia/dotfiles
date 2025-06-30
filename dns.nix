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
    "tessa.dog" = {
      "" = {
        ns = gcore-ns."".ns;
        mx.data = {
          exchange = "mail.tutanota.de";
          preference = 10;
        };
        txt.data = [
          "t-verify=31578bea730913aab7d9c88687d359a4"
          "v=spf1 include:spf.tutanota.de -all"
        ];
      };
      "s1._domainkey".cname.data = "s1.domainkey.tutanota.de";
      "s2._domainkey".cname.data = "s2.domainkey.tutanota.de";
      "_mta-sts".cname.data = "mta-sts.tutanota.de";
      "mta-sts".cname.data = "mta-sts.tutanota.de";
      "_dmarc".txt.data = "v=DMARC1; p=quarantine; adkim=s";
    };

    "catin.eu" = {
      "" = {
        ns = gcore-ns."".ns;
        mx.data = {
          exchange = "navy.elia.garden";
          preference = 10;
        };
        txt.data = "v=spf1 a:navy.elia.garden ~all";
      };
      "mail._domainkey".txt.data =
        "v=DKIM1;k=rsa;p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCpe+XScTCIGElLMIdBuQRYWC+jLoed5Z7AtbautKAblQec2JfYEjs0WFv1NcTXmHGlB9aH8nEjtf0popsGB0t/ywU6LhclZA5jsc6hc1037kfaXRfI/pGwcOHyuJRNu/RWthgP1Ac/EDf2QYzA3NPYpMJuntE9EpbvEMDQwC+adwIDAQAB";
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
      "mail._domainkey".txt.data =
        "v=DKIM1;k=rsa;p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDnn77i9ppRLxtgZ2FkrPYF9uIjR0sf8AXoH5br/+T6fSrT8JwSVqhkb9k/HHv9UrdABFNfNFsYZT1fjkdcr58WvpENnKb1YfjBr2kBsNczrHWK9z23tpmRpJeymshpXrmKBczYT/UKptAy+R7fS+W93AR+5yQsDBZfBcWwgTYYvQIDAQAB";
      "_dmarc".txt.data = "v=DMARC1;p=none";
    };
  };
}
