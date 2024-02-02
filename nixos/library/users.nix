{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    { programs.zsh.enable = true; }

    (lib.mkIf config.elia.graphical {
      users.users.leela = {
        isNormalUser = true;
        shell = pkgs.zsh;
        group = "leela";
        extraGroups = [ "wheel" ];
        hashedPassword = "$y$j9T$sHyEvuQc0WD/wi5fxThVv.$tSJK5ie2wmohukSp7tOIEwiOmTF/BPe7u2l/c.L0O79";
        openssh.authorizedKeys.keys = (import ../../secrets/keys.nix).ssh;
      };
      users.groups.leela = { };
      home-manager.users.leela = import ../../home/workstation.nix;
    })

    (lib.mkIf (!config.elia.graphical) { home-manager.users.root = import ../../home; })
  ];
}
