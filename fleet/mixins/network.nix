rec {
  networks = {
    near = {
      gateway = "192.168.0.1";
      prefix = 24;
      nameservers = [ "192.168.0.100" ];
    };

    far = {
      gateway = "10.0.0.1";
      prefix = 16;
      nameservers = [ "10.0.1.10" ];
    };
  };

  hosts = {
    haze = networks.near // {
      mac = "3c:ec:ef:ea:f4:67";
      address = "192.168.0.100";

      wg = {
        key = "qjYusX9sLoL0IOHi7hdnbAus9WIqa3lplEZMZ9QWkEg=";
        ip = "10.45.0.2";
      };
    };

    hazyboi = networks.near // {
      mac = "f4:b5:20:50:ef:55";
      address = "192.168.0.10";

      wg = {
        key = "POmbXmW6t1fCyorK3vCcmiZtrusndPrKzieotwOT02w=";
        ip = "10.45.0.4";
      };
    };

    mauve = {
      # This is a mobile device using WLAN, static IPv4 configuration
      # does not make sense since it is often in foreign networks.
      # The address in `near` is instead assigned at the DHCP server
      address = "192.168.0.212";

      wg = {
        key = "UikEcq+qAfPSfoMM+2FBFFezpr+GMNvySxEa6f+3iDI=";
        ip = "10.45.0.3";
      };
    };

    navy = {
      address = "202.61.255.155";

      wg = {
        key = "8ezeQyYgoWhhTILBoXy7ABSCR87pHbjr+LMCVtcU038=";
        ip = "10.45.0.1";
        endpoint = "202.61.255.155:50220";
      };
    };

    celadon.address = "10.0.0.1";
  };
}
