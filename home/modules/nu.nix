{ pkgs, config, ... }: {
  programs.carapace = {
    enable = true;
    enableZshIntegration = false;
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
    };

    shellAliases = config.elia.shellAliases;
  };
}
