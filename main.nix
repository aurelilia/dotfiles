{ config, lib, pkgs, ... }:
{
  options = {
    dots.kind = lib.mkOption {
      type = lib.types.enum [ "server" "desktop" "laptop" ];
    };
    dots.base = lib.mkOption {
      type = lib.types.enum [ "arch" "nix" ];
    };
  };

  imports = [
    ./packages.nix
    ./modules/bat.nix
    ./modules/git.nix
    ./modules/lsd.nix
    ./modules/micro.nix
    ./modules/ssh.nix
    ./modules/starship.nix
    ./modules/zsh.nix
  ];

  config = (lib.mkMerge [
    {
      home.username = lib.mkDefault (builtins.getEnv "USER");
      home.homeDirectory = lib.mkDefault ("/home/${config.home.username}");
      home.stateVersion = "23.11";
      home.file.".local/bin".source = files/bin;

      programs.home-manager.enable = true;
      targets.genericLinux.enable = config.dots.base != "nix";

      home.activation."diff" = ''
        ${pkgs.nvd}/bin/nvd --color=always diff "$oldGenPath" "$newGenPath"
        ${pkgs.colordiff}/bin/colordiff \
          --nobanner --fakeexitcode --color=always -ur -I '\/nix\/store' \
          -x "home-path" \
          -- "$oldGenPath" "$newGenPath"
      '';
    }
    (lib.mkIf (config.dots.kind != "server") {
        home.sessionVariables = {
          PATH = "$HOME/.local/bin:$HOME/.cargo/bin:$PATH";
        };
    
        fonts.fontconfig.enable = true;

        systemd.user = {
          startServices = true;
          systemctlPath = "/usr/bin/systemctl";
        };
        
        nixpkgs.overlays = lib.singleton (
          self: super:
          {
            wrapWithNixGL = package:
              let
                binFiles = lib.pipe "${lib.getBin package}/bin" [
                  builtins.readDir
                  builtins.attrNames
                  (builtins.filter (n: builtins.match "^\\..*" n == null))
                ];
                wrapBin =
                  name:
                  self.writeShellScriptBin name ''
                    exec /home/leela/.nix-profile/bin/nixGLIntel ${package}/bin/${name} "$@"
                  '';
              in
              self.symlinkJoin {
                name = "${package.name}-nixgl";
                paths = (map wrapBin binFiles) ++ [ package ];
              };
          }
        );
      })
  ]);
}
