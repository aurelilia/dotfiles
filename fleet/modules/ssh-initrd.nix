{ ... }: {
  boot.initrd.network = {
    enable = true;
    udhcpc.enable = true;

    postCommands = ''
      # Import all pools
      zpool import -a
      # Add the load-key command to the .profile
      echo "zfs load-key -a; killall zfs" >> /root/.profile
    '';

    ssh = {
      enable = true;
      port = 2222;
      hostKeys = [ "/etc/nixos/ssh_host_ed25519_key" ];
    };
  };
}