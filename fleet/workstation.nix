{ name, nodes, config, lib, pkgs, ... }: {
  imports = [ ./modules/gui.nix ];

  nixpkgs.config.allowUnfree = true;

  # Dotfiles
  users.users.leela = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "leela" ];
    initialHashedPassword = "changeme";
  };
  users.groups.leela.gid = 1000;
  home-manager.users.leela = import ../home/workstation-nix.nix;

  # Ethereal, expected to be present on workstations and owned by leela.
  # Usually also a mountpoint, but we still want permissions to be correct
  system.activationScripts.makeEthereal = ''
    mkdir -p /ethereal/cache
    chown -R 1000:1000 /ethereal
  '';

  /* TODO why does this not do anything :(
       https://stackoverflow.com/questions/68523367/
     nixpkgs.overlays = [
       (final: prev: {
         xkeyboard-config = prev.xkeyboard-config.overrideDerivation (old: {
           buildCommand = ''
             set -euo pipefail

             ${
               # Copy original files, for each split-output (`out`, `dev` etc.).
               # E.g. `${package.dev}` to `$dev`, and so on. If none, just "out".
               lib.concatStringsSep "\n"
                 (map
                   (outputName:
                     ''
                       echo "Copying output ${outputName}"
                       set -x
                       cp -rs --no-preserve=mode "${pkgs.xkeyboard-config.${outputName}}" "''$${outputName}"
                       set +x
                     ''
                   )
                   (old.outputs or ["out"])
                 )
             }

             install -v "${../home/misc/files/us}" "$out"/share/X11/xkb/symbols/us
           '';
         });
       })
     ];
  */
}
