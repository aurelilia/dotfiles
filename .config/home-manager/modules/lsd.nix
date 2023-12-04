{ config, pkgs, ... }:
{
  programs.lsd.enable = true;
  programs.zsh.shellAliases = {
    ls = "ls -lFh";
  };
}