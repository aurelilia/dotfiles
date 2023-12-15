# This file is currently unused; template for bootstrapping a new host
{ home-manager, nixpkgs, ... }:
{
  navy = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./main.nix
      ../hosts/navy
    ];
  };
}
