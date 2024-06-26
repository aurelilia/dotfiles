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

      users.users.root.openssh.authorizedKeys.keys = (import ../../../secrets/keys.nix).ssh;

      # I want mosh for times where my connection isn't great
      # This is a simple blanket enable on all systems since all either
      # need the server or client regardless
      programs.mosh.enable = true;

      # ZnapZend uses SSH to transfer ZFS datasets, which requires using the
      # correct identity file. For some reason this is not done by default?
      system.activationScripts."Add SSH identity to root".text = ''
        mkdir -p /root/.ssh/
        echo "IdentityFile ${ed-key}" > /root/.ssh/config
      '';
    }

    (lib.mkIf config.feline.initrd-ssh.enable {
      # Initrd SSH with ZFS unlock on port 2222.
      boot.initrd.network = {
        enable = true;
        udhcpc.enable = lib.mkDefault true;

        postCommands = ''
          if type "zpool" > /dev/null; then
            # Import all pools
            zpool import -a
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

  options.feline.initrd-ssh.enable = lib.mkEnableOption "SSH initrd unlocking";
}
