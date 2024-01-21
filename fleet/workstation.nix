{ name, nodes, config, lib, pkgs, ... }: {
  imports = [ ./optional/gui.nix ];

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

  # Misc services I want
  services.gvfs.enable = true;
  boot.supportedFilesystems = [ "ntfs" ];
  virtualisation.docker.enable = true;
}
