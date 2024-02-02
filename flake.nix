{
  description = "aurlila's full system configurations using Nix, NixOS, and HM";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.darwin.follows = "";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
      agenix,
      disko,
      nixgl,
      ...
    }:
    let
      hostSystem = "x86_64-linux";
      nixpkgsHost = import nixpkgs-unstable { system = hostSystem; };
    in
    {
      devShells.${hostSystem}.default = nixpkgsHost.mkShell {
        buildInputs = [
          nixpkgsHost.colmena
          agenix.packages.${hostSystem}.default
          nixpkgsHost.nixfmt-rfc-style
        ];
      };

      colmena = import ./fleet.nix {
        inherit
          nixpkgs
          nixpkgs-unstable
          home-manager
          agenix
          disko
          nixgl
          ;
      };
    };
}
