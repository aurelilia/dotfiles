{ config, lib, pkgs, ... }: {
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
        path = "/persist/secrets/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  users.users.root.openssh.authorizedKeys.keys =
    (import ../../secrets/keys.nix).ssh;
}
