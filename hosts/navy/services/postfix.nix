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
    sendingFqdn = "navy.elia.garden";
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
