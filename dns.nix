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
    "catin.eu" = {
      "" = {
        ns = gcore-ns."".ns;
        mx.data = {
          exchange = "mail.catin.eu";
          preference = 10;
        };
        txt.data = "v=spf1 a:mail.catin.eu ~all";
      };
      "mail._domainkey".txt.data =
        "v=DKIM1;k=rsa;p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCpe+XScTCIGElLMIdBuQRYWC+jLoed5Z7AtbautKAblQec2JfYEjs0WFv1NcTXmHGlB9aH8nEjtf0popsGB0t/ywU6LhclZA5jsc6hc1037kfaXRfI/pGwcOHyuJRNu/RWthgP1Ac/EDf2QYzA3NPYpMJuntE9EpbvEMDQwC+adwIDAQAB";
      "_dmarc".txt.data = "v=DMARC1;p=none";
    };
    "elentari.eu" = {
      "" = {
        ns = gcore-ns."".ns;
        mx.data = {
          exchange = "mail.catin.eu";
          preference = 10;
        };
        txt.data = "v=spf1 a:mail.catin.eu ~all";
      };
      "mail._domainkey".txt.data =
        "v=DKIM1;k=rsa;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAs3EmzRaQkxFMWH3nfVb+t8zXXPoQgfKjwfmbkPsmwY70XbHtWorPyIKkZEX5Zqn0835iKuJcfvDLEhYdn67TyDhlalPki6TKU93Cb2LGgyy/aVgxwCkUYLRSb62mYdONsdc4trMr3+K+a62MbSidlgyVz9hAhRxlnpfx8y5ifDmmqNm+ikVWk0A+CSoZZ1oTkXozSb2ltQdVyCHPpjW9X5ZeM2z4c1XSHA721kGRWYLHkbhu9I5l4wUUcMjO/Ry6LbxNui50ZoFw7+MZZIEzBjIhUaHBTtnDBc8uEovINQq4y4nbu9AylYmxOEBQJu6KrftAdWnlp3dIOjg4z563CQIDAQAB";
      "_dmarc".txt.data = "v=DMARC1;p=none";
    };
  };
}
