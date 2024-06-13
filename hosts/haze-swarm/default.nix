{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ./disko.nix
  ];

  feline = {
    mountPersistAtBoot = false;
    tailscale.enable = true;
  };

  programs.zsh.enable = true;
  users.users.root.shell = pkgs.zsh;
}
