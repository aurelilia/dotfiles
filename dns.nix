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
      "_dmarc".txt.data = "v=DMARC1;p=quarantine";
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
      "_dmarc".txt.data = "v=DMARC1;p=quarantine";
    };
    "mikalis.eu" = {
      "" = {
        mx.data = [
          {
            exchange = "mail.protonmail.ch";
            preference = 10;
          }
          {
            exchange = "mailsec.protonmail.ch";
            preference = 20;
          }
        ];
        txt.data = [
          "protonmail-verification=1d650830e9775f2bbce05dffa69511139a97558d"
          "v=spf1 include:_spf.protonmail.ch ~all"
        ];
      };
      "protonmail._domainkey".cname.data =
        "protonmail.domainkey.dad6tzkrnpndc2vkiqwjpbhukecdfdhtozn4alxcbyimdomqeybka.domains.proton.ch";
      "protonmail2._domainkey".cname.data =
        "protonmail2.domainkey.dad6tzkrnpndc2vkiqwjpbhukecdfdhtozn4alxcbyimdomqeybka.domains.proton.ch";
      "protonmail3._domainkey".cname.data =
        "protonmail3.domainkey.dad6tzkrnpndc2vkiqwjpbhukecdfdhtozn4alxcbyimdomqeybka.domains.proton.ch";
      "_dmarc".txt.data = "v=DMARC1;p=quarantine";
    };
    "silex-da.de" = {
      "" = {
        ns = gcore-ns."".ns;
        mx.data = {
          exchange = "mail.catin.eu";
          preference = 10;
        };
        txt.data = "v=spf1 a:mail.catin.eu ~all";
      };
      "mail._domainkey".txt.data =
        "v=DKIM1;k=rsa;p=p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkUFa2Zdn7Cu0g1oEtU5N1C/R1qhbWpWDOeRbkXtloLaGmnI+JZKzKFsIHruVR86byplxlTpOe4mR5ue5uMadLydr95eaxMeqRyo4MSF4imYWofxXXAT3+rAzXUsZ2FulIZGnI0D8eOfic0yJJff35D8gfNCFxmYc83cc8NXJ7c3u+Ckwd/wOLNusOui2DofvIjc4PEAtXUS3tx4u/7imN936iviEO+aydNRTEQHf6X/IMqhWXmh6/vrzZ8HQwztxhdwGGZ5UJD4v7qhxPpao2tmlFwe0jzRuWe6f7zF93vB4mAE1YIOIDiwoCA3JplPe9C5ky9zQ/1iOGYI4wzScBwIDAQAB";
      "_dmarc".txt.data = "v=DMARC1;p=quarantine";
    };
  };
}
