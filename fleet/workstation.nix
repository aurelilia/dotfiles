{
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  # Thank you, piegames!
  # https://git.darmstadt.ccc.de/piegames/home-config/-/blob/master/main.nix?ref_type=heads 
  wrapWithNixGL =
    package:
    let
      binFiles = lib.pipe "${lib.getBin package}/bin" [
        builtins.readDir
        builtins.attrNames
        (builtins.filter (n: builtins.match "^\\..*" n == null))
      ];
      wrapBin =
        name:
        pkgs-unstable.writeShellScriptBin name ''
          exec ${pkgs-unstable.nixgl.nixGLIntel}/bin/nixGLIntel ${package}/bin/${name} "$@"
        '';
    in
    pkgs-unstable.symlinkJoin {
      name = "${package.name}-nixgl";
      paths = (map wrapBin binFiles) ++ [ package ];
    };
in
{
  imports = [ ./optional/gui.nix ];

  # Dotfiles
  users.users.leela = {
    isNormalUser = true;
    shell = pkgs.zsh;
    group = "leela";
    extraGroups = [ "wheel" ];
    hashedPassword = "$y$j9T$sHyEvuQc0WD/wi5fxThVv.$tSJK5ie2wmohukSp7tOIEwiOmTF/BPe7u2l/c.L0O79";
    openssh.authorizedKeys.keys = (import ../secrets/keys.nix).ssh;
  };
  users.groups.leela = { };
  home-manager.users.leela = import ../home/workstation.nix;

  # Misc services I want
  services.gvfs.enable = true;
  boot.supportedFilesystems = [ "ntfs" ];
  virtualisation.docker.enable = true;

  # Packages I want from unstable, whose version in stable is too outdated
  lib.pkgs-unstable = pkgs-unstable;
  users.users.leela.packages = with pkgs-unstable; [ (wrapWithNixGL logseq) ];
}
