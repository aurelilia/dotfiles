{ pkgs, ... }:
{
  users.users.vivi = {
    isSystemUser = true;
    group = "vivi";
    home = "/backup/vivi";
    createHome = true;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [ (import ../../../secrets/keys.nix).vivi ];
  };
  users.groups.vivi = { };
}
