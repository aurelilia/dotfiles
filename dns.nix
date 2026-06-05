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
  zones."catin.eu" = {
    "" = {
      ns = gcore-ns."".ns;
      mx.data = {
        exchange = "manul.elia.garden";
        preference = 10;
      };
      txt.data = "v=spf1 a:manul.elia.garden ~all";
    };
    "mail._domainkey".txt.data =
      "v=DKIM1;k=rsa;p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCpe+XScTCIGElLMIdBuQRYWC+jLoed5Z7AtbautKAblQec2JfYEjs0WFv1NcTXmHGlB9aH8nEjtf0popsGB0t/ywU6LhclZA5jsc6hc1037kfaXRfI/pGwcOHyuJRNu/RWthgP1Ac/EDf2QYzA3NPYpMJuntE9EpbvEMDQwC+adwIDAQAB";
    "_dmarc".txt.data = "v=DMARC1;p=none";
  };
}
