{ ... }:
let
  sieveScript = builtins.readFile ./filter.sieve;
in
{
  mailserver = {
    enable = true;
    stateVersion = 5;

    mailDirectory = "/persist/data/mail/mail";
    dkimKeyDirectory = "/persist/data/mail/dkim";
    indexDir = "/var/lib/dovecot/indices";

    fqdn = "catin.eu";
    sendingFqdn = "manul.elia.garden";
    domains = [
      "elia.garden"
      "catin.eu"
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

      "noreply@auth.catin.eu" = {
        hashedPassword = "$2b$05$TjbQF7BxfIZAp6BfG3LIBO2ToqCMJj9AlPc/ypCGaerrAXrjJ5day";
      };
      "noreply@social.catin.eu" = {
        hashedPassword = "$2b$05$GalNO3SzDlHXh6uzBA1uQe.j6btuLudSlAOOaej9dectYb5pQfLfO";
      };
    };

    fullTextSearch = {
      enable = true;
      autoIndex = true;
    };

    x509 = {
      certificateFile = "/persist/data/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/catin.eu/catin.eu.crt";
      privateKeyFile = "/persist/data/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/catin.eu/catin.eu.key";
    };
  };
}
