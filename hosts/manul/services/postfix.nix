{ ... }:
let
  sieveScript = builtins.readFile ./filter.sieve;
in
{
  # Populate DNS record
  feline.caddy.routes."mail.catin.eu".redir = "catin.eu";

  mailserver = {
    enable = true;
    stateVersion = 5;

    storage.path = "/persist/data/mail/mail";
    dkim.keyDirectory = "/persist/data/mail/dkim";
    indexDir = "/var/lib/dovecot/indices";

    fqdn = "mail.catin.eu";
    domains = [
      "elia.garden"
      "catin.eu"
      "elentari.eu"
      "silex-da.de"
    ];
    accounts = {
      "leela@catin.eu" = {
        inherit sieveScript;
        hashedPassword = "$2b$05$eCjOxdKHKdrqgFpzWN0M5.R1du0NVIhs8zo/aB6kM3F12lbbIGg96";
        aliases = [
          "@catin.eu"
          "@elia.garden"
        ];
      };

      "kara@elentari.eu" = {
        inherit sieveScript;
        hashedPassword = "$y$j9T$y2GUU396GuN7Fmejr9byR1$ulv7kDoTQLMIzfr5ArYQa3lt0j6fd4HDKulYAWO3vF4";
        aliases = [ "@elentari.eu" ];
      };

      "festival@silex-da.de" = {
        hashedPassword = "$y$j9T$IGNksFFOKz7Yqb47/rjvu0$kT33X5b/2J7JmBudW3AqAkEnatOagr8QvvacchMpNU5";
      };
      "verein@silex-da.de" = {
        hashedPassword = "$y$j9T$nY2St.pSQ1Chti79RJ8Zx0$sosXp0z.SwM9lm4Ycrjdl6Dbg57.tEn8..6y2lFpM21";
      };
      "admin@silex-da.de" = {
        hashedPassword = "$y$j9T$203nJk7EDeMaBVADO1nKK.$gzhgvgDuLnm01TSyx1Alf4tBhkUpA7bBHzo6jm2Bl6.";
        aliases = [ "@silex-da.de" ];
      };

      "noreply@auth.catin.eu" = {
        hashedPassword = "$2b$05$TjbQF7BxfIZAp6BfG3LIBO2ToqCMJj9AlPc/ypCGaerrAXrjJ5day";
      };
    };

    fullTextSearch = {
      enable = true;
      autoIndex = true;
    };

    x509 = {
      certificateFile = "/persist/data/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/mail.catin.eu/mail.catin.eu.crt";
      privateKeyFile = "/persist/data/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/mail.catin.eu/mail.catin.eu.key";
    };
  };
}
