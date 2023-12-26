let
  leela = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyackPHAi1dToh8rb1E9nkeWZA19DTt5/qfHrDNZbNWojWN2axWB6fUvOPDWsfi7vszX/I9gmqo+qztcyVOmeu4FlPO9nQfCbpXfdrrUmLje/WzuWQeChnqC73D26dJmgxvTT3ytE2sovVMvXZEB+yAYDFPA0DU4C1VdtwU7nXbB4u9z3IwD9+nOTBTEcPcMLMrSpP8fDDfvjXSDvfIdeg0TBun6zNoSyO8RiVX38CKy+UEQKGcP2mc/gIrgdgGPdNoNiYXN7vXIr1kXXutbQ7BaifQuA9ryw+AmrhSMzhBHtx5Gx1Y0MbruVXvtNGlzE78r7r4kASJbVC/qTfKj7p leela@mauve";
  
  mauve = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBcgB0MWHDtutAz/MomjqK0kt3auZ4lg/BZIEImsq66q";
  navy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDGAeAfFlx5dwh0/NHkEoffxzcjVjG5wtsze00cANiDr";
  haze = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBXofGKR0wV5Qy0S8EWkZ7A4E15asz7wtGYhSwG14gyA";

  all = [ leela mauve navy haze ];
in
{
  "borg-repokey.age".publicKeys = all;
  "borg-ssh-id.age".publicKeys = all;
}
