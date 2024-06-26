let
  keys = import ./keys.nix;
in
{
  "borg-repokey.age".publicKeys = keys.borg;
  "borg-ssh-id.age".publicKeys = keys.borg;
  "tailscale-preauth.age".publicKeys = keys.all;
  "matrix-notify.age".publicKeys = keys.all;

  "navy/coturn-auth.age".publicKeys = with keys; [
    leela
    navy
  ];
  "navy/headscale-config.age".publicKeys = with keys; [
    leela
    navy
  ];
  "jade/bookstack-key.age".publicKeys = with keys; [
    leela
    jade
  ];
  "haze/streamrip.age".publicKeys = with keys; [
    leela
    haze
  ];
  "haze/mullvad.age".publicKeys = with keys; [
    leela
    haze
  ];
}
