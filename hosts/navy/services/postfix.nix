{ ... }: {
  mailserver = {
    enable = true;
    enableImap = false;
    enableImapSsl = false;

    fqdn = "mail.elia.garden";
    domains = [ "elia.garden" "catin.eu" ];
    forwards = {
      "@elia.garden" = "aurelila@mailbox.org";
      "@catin.eu" = "aurelila@mailbox.org";
    };
    certificateScheme = "selfsigned";
  };
}
