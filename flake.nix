{
  description = "aurlila's full system configurations using Nix, NixOS, and HM";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixgl.url = "github:guibou/nixGL";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { home-manager, nixpkgs, nixpkgs-stable, nixgl, ... }:
    let
      hostSystem = "x86_64-linux";
      nixpkgsHost = import nixpkgs { system = hostSystem; };
      workstationPkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ nixgl.overlay ];
      };
    in {
      devShells.${hostSystem}.default = nixpkgsHost.mkShell {
        buildInputs = [ nixpkgsHost.colmena ];
      };

      homeConfigurations = {
        "leela@hazyboi" = home-manager.lib.homeManagerConfiguration {
          pkgs = workstationPkgs;
          modules = [ ./hosts/hazyboi ];
        };
      };

      colmena = import ./fleet { inherit home-manager; nixpkgs = nixpkgs-stable; };
    };
}
