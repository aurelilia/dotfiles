let keys = import ./keys.nix;
in {
  "borg-repokey.age".publicKeys = keys.all;
  "borg-ssh-id.age".publicKeys = keys.all;
  "coturn-auth.age".publicKeys = with keys; [ leela navy ];
  "wg-gossip.age".publicKeys = keys.all;
  "headscale-oidc.age".publicKeys = with keys; [ leela navy ];
}
