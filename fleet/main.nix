{
  name,
  nodes,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./library ];

  # Locale
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";

  # Nix(OS) config
  system.stateVersion = "23.11";
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
  # This does not get set automatically for some reason?
  environment.variables.NIX_REMOTE = "daemon";

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
  };

  # Misc
  zramSwap.enable = true;
  virtualisation.libvirtd = {
    parallelShutdown = 5;
    qemu.runAsRoot = false;
  };
}
