rec {
  leela-old = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyackPHAi1dToh8rb1E9nkeWZA19DTt5/qfHrDNZbNWojWN2axWB6fUvOPDWsfi7vszX/I9gmqo+qztcyVOmeu4FlPO9nQfCbpXfdrrUmLje/WzuWQeChnqC73D26dJmgxvTT3ytE2sovVMvXZEB+yAYDFPA0DU4C1VdtwU7nXbB4u9z3IwD9+nOTBTEcPcMLMrSpP8fDDfvjXSDvfIdeg0TBun6zNoSyO8RiVX38CKy+UEQKGcP2mc/gIrgdgGPdNoNiYXN7vXIr1kXXutbQ7BaifQuA9ryw+AmrhSMzhBHtx5Gx1Y0MbruVXvtNGlzE78r7r4kASJbVC/qTfKj7p leela@mauve";
  leela = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHaBw1inXuNMKkMFIYtsif72XIIhNeB8Po7Koqx7Oird";
  vivi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOIiMZ3fAFG2Q0mDnspC25KPVsabvC7ClVb5HnAQuoCO";

  mauve = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBcgB0MWHDtutAz/MomjqK0kt3auZ4lg/BZIEImsq66q";
  hazyboi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILy/C1WwUJWfsZfGKvKlJ/y9v3nPbpUpBGdDeBv16XE+";
  navy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDGAeAfFlx5dwh0/NHkEoffxzcjVjG5wtsze00cANiDr";
  haze = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBXofGKR0wV5Qy0S8EWkZ7A4E15asz7wtGYhSwG14gyA";
  jade = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTTaHIF2zQr6uNVSWcZdL+Ld8/yKBzn6WyGXvQlUNb/";

  all = [
    leela
    mauve
    hazyboi
    navy
    haze
    jade
  ];
  zfs-sender = [
    mauve
    hazyboi
    haze
    jade
  ];
  zfs-receiver = {
    jade.publicKey = jade;
    haze.publicKey = haze;
  };
  ssh = [
    leela
    haze
  ];
}
