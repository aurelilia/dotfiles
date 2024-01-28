{ ... }: {
  networking.firewall.allowedTCPPorts = [ 53 8083 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  virtualisation.oci-containers.containers.pihole = {
    image = "pihole/pihole:latest";
    autoStart = true;
    extraOptions = [ "--net=host" "--cap-add=NET_ADMIN" ];
    volumes = [
      "/containers/pihole/pihole:/etc/pihole"
      "/containers/pihole/dnsmasq:/etc/dnsmasq.d"
    ];
    environment = {
      TZ = "Europe/Brussels";
      WEB_PORT = "8083";
    };
  };
}
