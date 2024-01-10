{ lib, ... }: {
  boot.initrd.network = {
    enable = true;
    udhcpc.enable = lib.mkDefault true;

    postCommands = ''
      if type "zpool" > /dev/null; then
        # Import all pools
        zpool import -a
        # Add the load-key command to the .profile
        echo "zfs load-key -a; killall zfs" >> /root/.profile
      fi
    '';

    ssh = {
      enable = true;
      port = 2222;
      hostKeys = [ "/persist/secrets/ssh/initrd/ssh_host_ed25519_key" ];
    };
  };
}
