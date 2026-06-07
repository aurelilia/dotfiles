{
  config,
  pkgs,
  lib,
  nixosConfig,
  ...
}:
{
  feline.shellAliases = {
    o = "xdg-open";
    ca = "bat -pp";
    va = "bat";
    ls = lib.mkForce "lsd -l";
    la = lib.mkForce "lsd -la";
    ssh-unlock = "ssh -p 2222";
  };
  home.sessionVariables.EDITOR = "micro";

  programs = {
    bat.enable = true;
    zoxide.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global.log_filter = "^$";
    };
    fzf = {
      enable = true;
      enableFishIntegration = false;
    };
    lsd = {
      enable = true;
      settings = {
        color.when = "always";
        icons.when = "always";
        date = "relative";
        sorting.dir-grouping = "first";
      };
    };
    micro = {
      enable = true;
      settings = {
        autosu = false;
        clipboard = "terminal";
      };
    };

    nushell = {
      enable = true;
      shellAliases = config.feline.shellAliases;
      configFile.text = ''
        source ${../files/nu/theme.nu}
        source ${../files/nu/config.nu}
        source ${../files/nu/funcs.nu}
      '';
    };

    fish = {
      enable = true;
      shellAliases = config.feline.shellAliases;

      plugins = [
        {
          name = "fzf";
          src = pkgs.fetchFromGitHub {
            owner = "PatrickF1";
            repo = "fzf.fish";
            rev = "8920367cf85eee5218cc25a11e209d46e2591e7a";
            sha256 = "T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
          };
        }
        {
          name = "replay";
          src = pkgs.fetchFromGitHub {
            owner = "jorgebucaran";
            repo = "replay.fish";
            rev = "d2ecacd3fe7126e822ce8918389f3ad93b14c86c";
            sha256 = "TzQ97h9tBRUg+A7DSKeTBWLQuThicbu19DHMwkmUXdg=";
          };
        }
      ];

      interactiveShellInit = ''
        # Quiet greeting
        set -U fish_greeting

        # nix-ld
        set -gx NIX_LD_LIBRARY_PATH "${lib.makeLibraryPath nixosConfig.environment.systemPackages}"
        set -gx NIX_LD "$(cat ${pkgs.stdenv.cc}/nix-support/dynamic-linker)"

        # fzf
        set -gx fzf_preview_file_cmd "${pkgs.pistol}/bin/pistol"
        fzf_configure_bindings --directory=\cf
        set -gx FZF_DEFAULT_OPTS "--height ~30% \
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
      '';
    };

    starship = {
      enable = true;

      settings = {
        format = "$directory$nix_shell$hostname$character";
        right_format = "$cmd_duration";
        add_newline = false;

        character = {
          success_symbol = "[λ](#b4befe) ›";
          error_symbol = "[λ](#f38ba8) ›";
        };

        directory = {
          format = "[]($style)[ ](bg:#24263a fg:#b4befe)[$path](bg:#24263a fg:#BBC3DF)[ ]($style)";
          style = "bg:none fg:#24263a";
          truncation_length = 1;
          truncate_to_repo = false;
          fish_style_pwd_dir_length = 1;
        };

        cmd_duration = {
          min_time = 100000;
          format = "[]($style)[in (bg:#24263a fg:#eba0ac bold)$duration](bg:#24263a fg:#BBC3DF)[ ]($style)";
          style = "bg:none fg:#24263a";
        };

        nix_shell.format = "❄️(bold blue) ";
        hostname.format = "[$hostname](bold red) ";
      };
    };
  };
}
