{ config, lib, pkgs, ... }: {
  services.openssh = {
    enable = true;
    openFirewall = true;
    extraConfig = "PrintLastLog no";
  };

  users.users.root.openssh.authorizedKeys.keys =
    [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyackPHAi1dToh8rb1E9nkeWZA19DTt5/qfHrDNZbNWojWN2axWB6fUvOPDWsfi7vszX/I9gmqo+qztcyVOmeu4FlPO9nQfCbpXfdrrUmLje/WzuWQeChnqC73D26dJmgxvTT3ytE2sovVMvXZEB+yAYDFPA0DU4C1VdtwU7nXbB4u9z3IwD9+nOTBTEcPcMLMrSpP8fDDfvjXSDvfIdeg0TBun6zNoSyO8RiVX38CKy+UEQKGcP2mc/gIrgdgGPdNoNiYXN7vXIr1kXXutbQ7BaifQuA9ryw+AmrhSMzhBHtx5Gx1Y0MbruVXvtNGlzE78r7r4kASJbVC/qTfKj7p leela@mauve" ];
}
