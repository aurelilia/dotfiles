{
  options,
  pkgs,
  lib,
  ...
}:
{
  programs.git = {
    enable = true;
    userName = "Leela Aurelia";
    userEmail = "git@elia.garden";

    aliases = { 
      pall = "!git remote | xargs -L1 -I R git push R main";
    };

    extraConfig = {
      core = {
        autocrlf = "input";
        editor = "micro";
      };
      github.user = "aurelilia";
      init.defaultBranch = "main";
    };
  };
}
