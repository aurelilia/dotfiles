{
  lib,
  pkgs,
  nixosConfig,
  ...
}:
{
  imports = [
    ./library/bat.nix
    ./library/git.nix
    ./library/lsd.nix
    ./library/micro.nix
    ./library/nu.nix
    ./library/starship.nix
    ./library/zsh.nix
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
      neofetch
      nvd
      rsync
      sshfs
      less
      ncdu
    ];

    catppuccin = nixosConfig.catppuccin;
  };

  options = {
    feline.shellAliases = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
}
