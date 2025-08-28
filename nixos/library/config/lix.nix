{ pkgs, pkgs-unstable, ... }:
let
  base = "/etc/nixpkgs/channels";
  nixpkgsPath = "${base}/nixpkgs";
  nixpkgsUnstablePath = "${base}/nixpkgs-unstable";
in
{
  system.stateVersion = "23.11";
  nix = {
    package = pkgs.lix;
    nixPath = [
      "nixpkgs=${nixpkgsPath}"
      "nixpkgs-unstable=${nixpkgsUnstablePath}"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Lix binary cache
      extra-substituters = [ "https://cache.lix.systems" ];
      trusted-public-keys = [ "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o=" ];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  # This does not get set automatically for some reason?
  environment.variables.NIX_REMOTE = "daemon";

  systemd.tmpfiles.rules = [
    "L+ ${nixpkgsPath}     - - - - ${pkgs.path}"
    "L+ ${nixpkgsUnstablePath} - - - - ${pkgs-unstable.path}"
  ];
}
