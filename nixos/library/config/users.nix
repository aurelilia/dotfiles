{
  config,
  lib,
  pkgs,
  catppuccin-hm,
  ...
}:
let
  cfg = config.feline.dotfiles;
in
{
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.fish.enable = true;
      programs.zsh.enable = true;
      users.users.root.shell = pkgs.fish;

      nix.settings.trusted-users = [ cfg.user ];
      home-manager.users.${cfg.user}.imports = [
        ../../../home
        catppuccin-hm
      ]
      ++ lib.optional cfg.full ../../../home/workstation.nix
      ++ lib.optional cfg.full-slim ../../../home/workstation-slim.nix;
    })

    (lib.mkIf cfg.create-user {
      users.users.${cfg.user} = {
        isNormalUser = true;
        shell = pkgs.fish;
        group = cfg.user;
        extraGroups = [ "wheel" ];
        hashedPassword = "$y$j9T$sHyEvuQc0WD/wi5fxThVv.$tSJK5ie2wmohukSp7tOIEwiOmTF/BPe7u2l/c.L0O79";
        openssh.authorizedKeys.keys = (import ../../../secrets/keys.nix).ssh;
      };
      users.groups.${cfg.user} = { };
    })
  ];

  options.feline.dotfiles = {
    user = lib.mkOption {
      type = lib.types.str;
      description = "User to install dotfiles for.";
    };

    enable = lib.mkEnableOption "Dotfiles";
    full = lib.mkEnableOption "full dotfiles";
    full-slim = lib.mkEnableOption "full dotfiles - slimmed";
    create-user = lib.mkEnableOption "user creation";
  };
}
