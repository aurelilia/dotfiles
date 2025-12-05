{ ... }:
let
  sieveScript = builtins.readFile ./filter.sieve;
in
{
  mailserver = {
    enable = true;
    stateVersion = 3;

    mailDirectory = "/persist/data/mail/mail";
    sieveDirectory = "/persist/data/mail/sieve";
    dkimKeyDirectory = "/persist/data/mail/dkim";
    indexDir = "/var/lib/dovecot/indices";

    fqdn = "catin.eu";
    sendingFqdn = "manul.elia.garden";
    domains = [
      "elia.garden"
      "catin.eu"
      "ehir.art"
    ];
    loginAccounts = {
      "leela@catin.eu" = {
        inherit sieveScript;
        hashedPassword = "$2b$05$eCjOxdKHKdrqgFpzWN0M5.R1du0NVIhs8zo/aB6kM3F12lbbIGg96";
        aliases = [
          "@catin.eu"
          "@elia.garden"
        ];
      };
      "berg@ehir.art" = {
        inherit sieveScript;
        hashedPassword = "$2b$05$yUAbKtU/5M6h.K.6jdkMuus3QRW8IIPHqxICi8kPFDYPxRZRxWT8a";
        aliases = [ "@ehir.art" ];
      };

      "noreply@auth.catin.eu" = {
        hashedPassword = "$2b$05$TjbQF7BxfIZAp6BfG3LIBO2ToqCMJj9AlPc/ypCGaerrAXrjJ5day";
      };
      "noreply@zulip.catin.eu" = {
        hashedPassword = "$2b$05$iFioMK0WM0BvkbXRSr3D8.I1mdVo9cfCRE08ybm3tyyQSUZdw1rI.";
      };
      "noreply@social.catin.eu" = {
        hashedPassword = "$2b$05$GalNO3SzDlHXh6uzBA1uQe.j6btuLudSlAOOaej9dectYb5pQfLfO";
      };
    };

    fullTextSearch = {
      enable = true;
      autoIndex = true;
      enforced = "body";
    };

    certificateScheme = "manual";
    certificateFile = "/persist/data/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/catin.eu/catin.eu.crt";
    keyFile = "/persist/data/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/catin.eu/catin.eu.key";
  };
}
