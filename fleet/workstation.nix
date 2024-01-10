{ name, nodes, config, lib, pkgs, ... }: {
  imports = [ ./modules/gui.nix ./modules/plymouth.nix ];

  # Dotfiles
  users.users.leela = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "leela" ];
    hashedPassword =
      "$y$j9T$sHyEvuQc0WD/wi5fxThVv.$tSJK5ie2wmohukSp7tOIEwiOmTF/BPe7u2l/c.L0O79";
    openssh.authorizedKeys.keys = (import ../secrets/keys.nix).ssh;
  };
  users.groups.leela.gid = 1000;
  home-manager.users.leela = import ../home/workstation.nix;

  # Ethereal, expected to be present on workstations and owned by leela.
  # Usually also a mountpoint, but we still want permissions to be correct
  system.activationScripts.makeEthereal = ''
    mkdir -p /ethereal/cache
    chown -R 1000:1000 /ethereal
  '';

  # GVFS is wanted for volume management / user mounting
  services.gvfs.enable = true;
}
