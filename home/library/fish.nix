{ config, pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    # Using jethrokuan/fzf
    enableFishIntegration = false;
  };
  programs.zoxide.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  feline.shellAliases = {
    o = "xdg-open";
  };

  programs.fish = {
    enable = true;
    shellAliases = config.feline.shellAliases // {
      c = "__fzf_cd";
      f = "__fzf_open";
    };

    plugins = [
      {
        name = "fzf";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "fzf";
          rev = "479fa67d7439b23095e01b64987ae79a91a4e283";
          sha256 = "28QW/WTLckR4lEfHv6dSotwkAKpNJFCShxmKFGQQ1Ew=";
        };
      }
      {
        name = "replay";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "replay.fish";
          rev = "d2ecacd3fe7126e822ce8918389f3ad93b14c86c";
          sha256 = "28QW/WTLckR4lEfHv6dSotwkAKpNJFCShxmKFGQQ1Ew=";
        };
      }
    ];

    interactiveShellInit = ''
      # Quiet greeting
      set -U fish_greeting

      # Quiet direnv
      set -gx DIRENV_LOG_FORMAT ""

      # fzf
      set -U FZF_COMPLETE 2
      set -U FZF_PREVIEW_FILE_CMD "${pkgs.pistol}/bin/pistol"
      # This needs re-sourcing for some reason?
      source ~/.config/fish/conf.d/plugin-fzf.fish
      set -gx FZF_DEFAULT_OPTS "--height ~30% \
      --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
      --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
      --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
    '';
  };
}
