{ ... }:
{
  services.atuin = {
    enable = true;
    openRegistration = true;
  };

  services.postgresql.enable = true;
  elia.caddy.routes."atuin.elia.garden".port = 8888;
}
