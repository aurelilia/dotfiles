{ pkgs, lib, config, ... }: {
  imports = [ ./workstation.nix ];

  home.packages = with pkgs; [
    # Graphical
    nixgl.nixGLIntel
    (wrapWithNixGL firefox)
    (wrapWithNixGL thunderbird)
    (wrapWithNixGL obs-studio)
    (wrapWithNixGL alacritty)
  ];

  systemd.user.systemctlPath = "/usr/bin/systemctl";
  targets.genericLinux.enable = true;

  nixpkgs.overlays = lib.singleton (self: super: {
    wrapWithNixGL = package:
      let
        binFiles = lib.pipe "${lib.getBin package}/bin" [
          builtins.readDir
          builtins.attrNames
          (builtins.filter (n: builtins.match "^\\..*" n == null))
        ];
        wrapBin = name:
          self.writeShellScriptBin name ''
            exec ${config.home.homeDirectory}/.local/state/nix/profile/bin/nixGLIntel ${package}/bin/${name} "$@"
          '';
      in self.symlinkJoin {
        name = "${package.name}-nixgl";
        paths = (map wrapBin binFiles) ++ [ package ];
      };
  });
}
