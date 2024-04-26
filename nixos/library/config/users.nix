{
  config,
  lib,
  pkgs,
  catppuccin-hm,
  ...
}:
{
  config = lib.mkMerge [
    {
      programs.zsh.enable = true;
      users.users.root.shell = pkgs.zsh;
    }

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
      home-manager.users.leela.imports = [
        ../../home/workstation.nix
        catppuccin-hm
      ];
    })

    (lib.mkIf (!config.elia.graphical) {
      home-manager.users.root.imports = [
        ../../home
        catppuccin-hm
      ];
    })
  ];
}
