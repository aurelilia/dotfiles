{
  pkgs,
  lib,
  config,
  nixosConfig,
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
        nixosConfig.lib.pkgs-unstable.writeShellScriptBin name ''
          exec ${nixosConfig.lib.nixgl.nixGLIntel}/bin/nixGLIntel ${package}/bin/${name} "$@"
        '';
    in
    nixosConfig.lib.pkgs-unstable.symlinkJoin {
      name = "${package.name}-nixgl";
      paths = (map wrapBin binFiles) ++ [ package ];
    };
in
{
  imports = [
    ./workstation-base.nix
  ];

  config = {
    programs.mpv.enable = true;
    services.ssh-agent.enable = true;
    services.jellyfin-mpv-shim.enable = true;

    home.packages = with pkgs; [
      # Graphical
      xournalpp
      keepassxc
      orca-slicer
      gimp
      signal-desktop
      wl-mirror
      ungoogled-chromium
      krita
      (wrapWithNixGL nixosConfig.lib.pkgs-unstable.joplin-desktop)

      # Desktop CLI
      distrobox
    ];
  };
}
