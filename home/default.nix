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

    catppuccin = {
      enable = true;
      flavor = "mocha";
      accent = "red";
    };
  };

  options = {
    feline.shellAliases = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
}
