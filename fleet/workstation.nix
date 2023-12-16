{ name, nodes, config, lib, pkgs, ... }: {
  imports = [
    ./modules/gui.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Dotfiles
  users.users.leela = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialHashedPassword = "changeme";
  };
  home-manager.users.leela = import ../home/workstation-nix.nix;
}
