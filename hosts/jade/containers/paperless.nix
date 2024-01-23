{ config, ... }:
let url = "docs.elia.garden";
in {
  elia.containers.paperless = {
    mounts."/var/lib/paperless" = {
      hostPath = "/media/personal/documents/paperless";
      isReadOnly = false;
    };

    config = { ... }: {
      networking.firewall.allowedTCPPorts = [ 28981 ];
      services.paperless = {
        enable = true;
        address = "0.0.0.0";
        extraConfig = {
          PAPERLESS_OCR_LANGUAGE = "deu+eng";
          PAPERLESS_URL = "https://${url}";
        };
      };
    };
  };

  elia.caddy.routes."${url}".extraConfig = ''
    ${config.lib.caddy.snippets.sso-proxy}
    reverse_proxy paperless:28981
  '';
}
