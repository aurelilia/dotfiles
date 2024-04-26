{ ... }:
{
  system.stateVersion = "23.11";
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
  # This does not get set automatically for some reason?
  environment.variables.NIX_REMOTE = "daemon";
}
