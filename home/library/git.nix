{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "leela aurelia Elentári";
        email = "tech.git@catin.eu";
      };
      alias = {
        pall = "!git remote | xargs -I R git push R main";
        amend = "git add -u && git commit --amend";
      };

      # https://jvns.ca/blog/2024/02/16/popular-git-config-options/
      core = {
        autocrlf = "input";
        editor = "micro";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      merge.conflictstyle = "zdiff3";
      rerere.enabled = true;
    };
  };

  programs.git-credential-oauth.enable = true;
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
