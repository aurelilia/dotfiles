{ pkgs, ... }:
{
  users.users.piegames = {
    isSystemUser = true;
    group = "piegames";
    home = "/backup/piegames";
    createHome = true;
    shell = pkgs.bashInteractive;
    packages = [ pkgs.bupstash ];
    openssh.authorizedKeys.keys =
      let
        keys = (import ../../../secrets/keys.nix);
      in
      [
        keys.piegames
        ''command="bupstash serve --allow-init --allow-put /backup/piegames/bupstash",restrict ${keys.piegames-backup}''
      ];
  };
  users.groups.piegames = { };
}
