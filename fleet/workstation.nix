{ name, nodes, config, lib, pkgs, ... }: {
  imports = [ ./modules/gui.nix ./modules/plymouth.nix ];

  nixpkgs.config.allowUnfree = true;

  # Dotfiles
  users.users.leela = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "leela" ];
    hashedPassword =
      "$y$j9T$sHyEvuQc0WD/wi5fxThVv.$tSJK5ie2wmohukSp7tOIEwiOmTF/BPe7u2l/c.L0O79";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyackPHAi1dToh8rb1E9nkeWZA19DTt5/qfHrDNZbNWojWN2axWB6fUvOPDWsfi7vszX/I9gmqo+qztcyVOmeu4FlPO9nQfCbpXfdrrUmLje/WzuWQeChnqC73D26dJmgxvTT3ytE2sovVMvXZEB+yAYDFPA0DU4C1VdtwU7nXbB4u9z3IwD9+nOTBTEcPcMLMrSpP8fDDfvjXSDvfIdeg0TBun6zNoSyO8RiVX38CKy+UEQKGcP2mc/gIrgdgGPdNoNiYXN7vXIr1kXXutbQ7BaifQuA9ryw+AmrhSMzhBHtx5Gx1Y0MbruVXvtNGlzE78r7r4kASJbVC/qTfKj7p leela@mauve"
    ];
  };
  users.groups.leela.gid = 1000;
  home-manager.users.leela = import ../home/workstation.nix;

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
