{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./library/git.nix
    ./library/shell.nix
  ];

  config = {
    home.username = lib.mkDefault "root";
    home.homeDirectory = lib.mkDefault "/root";

    home.stateVersion = "23.11";
    home.packages = with pkgs; [
      apprise
      colordiff
      fd
      htop
      hyfetch
      nvd
      rsync
      sshfs
      less
      ncdu
      wget
      comma
    ];
  };

  options = {
    feline.shellAliases = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
}
