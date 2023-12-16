{ name, nodes, config, lib, pkgs, ... }: {
  imports = [
    ./modules/docker.nix
    ./modules/network.nix
    ./modules/ssh.nix
  ];

  # Locale related stuff
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";

  # Base Nix(OS) config
  system.stateVersion = "23.11";
  system.autoUpgrade.enable = true;
  nix.settings.allowed-users = [ "root" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  # Root user / Dotfiles
  programs.zsh.enable = true;
  users = {
    motd = "nixos welcomes u c:";
    users.root = {
      shell = pkgs.zsh;
      initialHashedPassword = "";
    };
  }; 
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.root = import ../home/server.nix;
  };
}
