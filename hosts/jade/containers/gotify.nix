{ config, ... }: {
  elia.containers.gotify = {
    mounts."/var/lib/gotify-server" = {
      hostPath = "/containers/gotify";
      isReadOnly = false;
    };

    config = { ... }: {
      networking.firewall.allowedTCPPorts = [ 80 ];
      services.gotify = {
        enable = true;
        port = 80;
      };
    };
  };

  elia.caddy.routes."notify.elia.garden".extraConfig = ''
    reverse_proxy gotify:80
  '';
}
