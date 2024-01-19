{ pkgs, ... }: {
  programs.atuin.enable = true;
  programs.zoxide.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.nushell = {
    enable = true;
    configFile.text = ''
      source ${../files/nu/theme.nu}
      source ${../files/nu/config.nu}
      source ${../files/nu/funcs.nu}
    '';

    environmentVariables = {
      # Quiet direnv
      DIRENV_LOG_FORMAT = "''";
      # Atuin sync
      ATUIN_SYNC_ADDRESS = "https://atuin.elia.garden";
    };

    shellAliases = {
      hm-switch = "home-manager --impure --flake path:. switch";
      hm-switch-git =
        "home-manager --impure --flake github:aurelila/dotfiles switch";
      nulclean = ''ssh -q navy -t "rm /containers/caddy/srv/file/*"'';
    };
  };
}
