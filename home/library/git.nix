{ ... }:
{
  programs.git = {
    enable = true;
    userName = "Leela Aurelia";
    userEmail = "git@elia.garden";

    aliases = {
      pall = "!git remote | xargs -I R git push R main";
      amend = "git add -u && git commit --amend";
    };

    delta.enable = true;

    extraConfig = {
      # https://jvns.ca/blog/2024/02/16/popular-git-config-options/
      core = {
        autocrlf = "input";
        editor = "micro";
      };
      github.user = "aurelilia";
      init.defaultBranch = "main";
      pull.rebase = true;
      merge.conflictstyle = "zdiff3";
      rerere.enabled = true;

      url = {
        "git@git.elia.garden:".insteadOf = "ge:";
        "git@github.com:".insteadOf = "gh:";
      };
    };
  };
}
