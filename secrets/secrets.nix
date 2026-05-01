let
  keys = import ./keys.nix;
in
{
  "borg-repokey.age".publicKeys = keys.borg;
  "borg-ssh-id.age".publicKeys = keys.borg;
  "tailscale-preauth.age".publicKeys = keys.all;
  "matrix-notify.age".publicKeys = keys.all;

  "haze/streamrip.age".publicKeys = with keys; [
    leela
    haze
  ];
  "haze/mullvad.age".publicKeys = with keys; [
    leela
    haze
  ];
}
