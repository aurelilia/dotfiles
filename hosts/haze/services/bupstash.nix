{ pkgs, ... }: {
  users.users.piegames = {
    isSystemUser = true;
    group = "piegames";
    home = "/backup/piegames";
    createHome = true;
    shell = pkgs.bashInteractive;
    openssh.authorizedKeys.keys = [ (import ../../../secrets/keys.nix).piegames ];
  };
  users.groups.piegames = { };
}
