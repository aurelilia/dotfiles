let keys = import ./keys.nix;
in {
  "borg-repokey.age".publicKeys = keys.all;
  "borg-ssh-id.age".publicKeys = keys.all;
}
