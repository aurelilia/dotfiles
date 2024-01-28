{ config, ... }: {
  age.secrets.coturn-auth = {
    file = ../../../secrets/navy/coturn-auth.age;
    owner = "turnserver";
    group = "turnserver";
  };

  networking.firewall = {
    allowedTCPPorts = [ 3478 5349 ];
    allowedUDPPorts = [ 3478 5349 ];
    allowedUDPPortRanges = [{
      from = 49152;
      to = 65535;
    }];
  };

  services.coturn = {
    enable = true;
    use-auth-secret = true;
    no-tcp-relay = true;
    no-tls = true;
    no-dtls = true;

    realm = "navy.elia.garden";
    relay-ips = [ "202.61.255.155" ];
    static-auth-secret-file = config.age.secrets.coturn-auth.path;

    extraConfig = ''
      # don't let the relay ever try to connect to private IP address ranges within your network (if any)
      # given the turn server is likely behind your firewall, remember to include any privileged public IPs too.
      denied-peer-ip=10.0.0.0-10.255.255.255
      denied-peer-ip=192.168.0.0-192.168.255.255
      denied-peer-ip=172.16.0.0-172.31.255.255

      # recommended additional local peers to block, to mitigate external access to internal services.
      # https://www.rtcsec.com/article/slack-webrtc-turn-compromise-and-bug-bounty/#how-to-fix-an-open-turn-relay-to-address-this-vulnerability
      no-multicast-peers
      denied-peer-ip=0.0.0.0-0.255.255.255
      denied-peer-ip=100.64.0.0-100.127.255.255
      denied-peer-ip=127.0.0.0-127.255.255.255
      denied-peer-ip=169.254.0.0-169.254.255.255
      denied-peer-ip=192.0.0.0-192.0.0.255
      denied-peer-ip=192.0.2.0-192.0.2.255
      denied-peer-ip=192.88.99.0-192.88.99.255
      denied-peer-ip=198.18.0.0-198.19.255.255
      denied-peer-ip=198.51.100.0-198.51.100.255
      denied-peer-ip=203.0.113.0-203.0.113.255
      denied-peer-ip=240.0.0.0-255.255.255.255

      user-quota=12 # 4 streams per video call, so 12 streams = 3 simultaneous relayed calls per user.
      total-quota=120
    '';
  };
}
