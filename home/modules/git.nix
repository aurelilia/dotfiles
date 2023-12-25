{ config, pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Leela Aurelia";
    userEmail = "git@elia.garden";

    aliases = {
      pall = "!git remote | xargs -I R git push R main";
      amend = "git add -u && git commit --amend";
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
