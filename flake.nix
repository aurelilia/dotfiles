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

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.darwin.follows = "";
    };
  };

  outputs = { home-manager, nixpkgs, nixpkgs-stable, nixgl, agenix, ... }:
    let
      hostSystem = "x86_64-linux";
      nixpkgsHost = import nixpkgs { system = hostSystem; };
      mkHome = module: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ nixgl.overlay ];
        };
        modules = [ module ];
      };
    in {
      devShells.${hostSystem}.default = nixpkgsHost.mkShell {
        buildInputs = [
          nixpkgsHost.colmena
          agenix.packages.${hostSystem}.default
        ];
      };

      homeConfigurations = {
        "leela@hazyboi" = mkHome ./hosts/hazyboi;
        "leela@coral" = mkHome ./hosts/coral;
      };

      colmena = import ./fleet { inherit home-manager agenix; nixpkgs = nixpkgs-stable; };
    };
}
