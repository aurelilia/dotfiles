{ config, lib, ... }:
let
  ed-key = "/persist/secrets/ssh/ssh_host_ed25519_key";
in
{
  config = lib.mkMerge [
    {
      services.openssh = {
        enable = true;
        openFirewall = true;
        settings.PasswordAuthentication = false;
        extraConfig = "PrintLastLog no";
        hostKeys = [
          {
            bits = 4096;
            path = "/persist/secrets/ssh/ssh_host_rsa_key";
            type = "rsa";
          }
          {
            path = ed-key;
            type = "ed25519";
          }
        ];
      };

      users.users.root.openssh.authorizedKeys.keys = (import ../../secrets/keys.nix).ssh;

      # ZnapZend uses SSH to transfer ZFS datasets, which requires using the
      # correct identity file. For some reason this is not done by default?
      system.activationScripts."Add SSH identity to root".text = ''
        mkdir -p /root/.ssh/
        echo "IdentityFile ${ed-key}" > /root/.ssh/config
      '';
    }

    (lib.mkIf (!config.boot.initrd.systemd.enable) {
      # Initrd SSH with ZFS unlock on port 2222.
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
    })
  ];
}
