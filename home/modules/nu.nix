{ pkgs, config, ... }: {
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

    shellAliases = config.elia.shellAliases;
  };
}
