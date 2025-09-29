rec {
  leela = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHaBw1inXuNMKkMFIYtsif72XIIhNeB8Po7Koqx7Oird";
  piegames = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0+vFmtDUgIg18r6a2ezNBRMrZVpAB6dhj37JDhYUu7CSr7o1pR8Sp/UUe/yAEjeyo0R/GfvKIKugCBDCd+6VsDuTkcWX9bwVdrelG3X7pIIt3tWdbqVVGZHFJ/qgdngvIYu3pY++ci6zFlBl8Z8SIXYXpDnVFYTvvBhDIOZJzvyyqL7B/Wm19fTf/HPLTtbuPFMg2gQxo8o5GW3Ow2keJRR1daSGYmGSA1y/F3UumoLuK85Zm0+Kt+yYTO2pMAUBN7Axv1yvnNGbdX9l+3eRHdKatfhCscs720cwR+HtMAfqvN1G5FAWnXdxPa8XIzyZIyrWRoEGPPuK1w2GlWUnDdYLVDMJOmLDz4TvYx2eodfWMRIdppLJYwWpv+Eg8JirO5bnbOnKzVM4C5ESYU8b1mRBI23ncqV+BAno+zehdzLPYg0q3N9wNDF6jqyw08YyiTDwlua4aZJzHDrDt7OjcFaC6t8W1/VimtE0bylhAzVeenJ8C+o3q2jPBvuNLIxk= piegames";
  piegames-backup = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYYYY9K51tyTLLF3j1SwqDDQX5pC8nuWD9Ncj4dgKYY backup@piegames";

  mauve = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBcgB0MWHDtutAz/MomjqK0kt3auZ4lg/BZIEImsq66q";
  hazyboi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILy/C1WwUJWfsZfGKvKlJ/y9v3nPbpUpBGdDeBv16XE+";
  haze = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBXofGKR0wV5Qy0S8EWkZ7A4E15asz7wtGYhSwG14gyA";
  bengal = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIBST5nykVjA+vC6D+RQXFR3MnEpLZnLgFKsBMlcvn28";
  mainecoon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAldVnwdJ6zAp54SgIhnD+ywT6yGLft2s9jtGuruAUlH";
  lowlander = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3huIw2Xd2xs+SHsaEc1PhysaKYxqzLRyu+uNtKh5ff";
  manul = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVdfNFegoXHzvX59rMCa7yDGpZsvnw+zNMD9/04xPbR";

  all = [
    leela
    mauve
    hazyboi
    haze
    bengal
    mainecoon
    lowlander
    manul
  ];
  borg = [
    leela
    mauve
    hazyboi
    haze
    bengal
    lowlander
    manul
  ];
  zfs-sender = [
    bengal
    mauve
    hazyboi
    haze
    lowlander
    manul
  ];
  zfs-receiver.haze.publicKey = haze;
  ssh = [
    leela
    haze
  ];
}
