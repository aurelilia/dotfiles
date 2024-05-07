{
  description = "aurlila's full system configurations using Lix, NixOS, and HM";

  inputs = {
    lix = {
      url = "git+https://git@git.lix.systems/lix-project/lix?ref=refs/tags/2.90-beta.1";
      flake = false;
    };
    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module";
      inputs.lix.follows = "lix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
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
    nixos-dns = {
      url = "github:Janik-Haag/nixos-dns";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs =
    inputs@{
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
      agenix,
      disko,
      nixgl,
      nixos-dns,
      catppuccin,
      lix-module,
      ...
    }:
    let
      hostSystem = "x86_64-linux";
      nixpkgsHost = import nixpkgs-unstable { system = hostSystem; };
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];
    in
    {
      devShells.${hostSystem}.default = nixpkgsHost.mkShell {
        buildInputs = [
          nixpkgsHost.colmena
          agenix.packages.${hostSystem}.default
          nixpkgsHost.nixfmt-rfc-style
          (nixpkgsHost.octodns.withProviders (
            ps:
            with nixpkgsHost;
            with python3Packages;
            [
              octodns-providers.bind
              (buildPythonPackage rec {
                pname = "octodns-gcore";
                version = "0.0.5-unstable";
                pyproject = true;

                src = fetchFromGitHub {
                  owner = "octodns";
                  repo = "octodns-gcore";
                  rev = "84ce0854a9a27cee9a00cae62049c402eb47c719";
                  hash = "sha256-v+NLsBSoTRUB35sxeF824v6uOcWK8/pCZTc9k3NH50A=";
                };

                nativeBuildInputs = [ setuptools ];

                propagatedBuildInputs = [
                  octodns
                  requests
                ];

                pythonImportsCheck = [ "octodns_gcore" ];
                nativeCheckInputs = [
                  pytestCheckHook
                  requests-mock
                ];

                meta = with lib; {
                  description = "GCore DNS provider for octoDNS";
                  homepage = "https://github.com/octodns/octodns-gcore/";
                  changelog = "https://github.com/octodns/octodns-gcore/blob/${src.rev}/CHANGELOG.md";
                  license = licenses.mit;
                };
              })
            ]
          ))
        ];
      };

      colmena = import ./nixos/entry.nix {
        nixpkgs = import nixpkgs { system = "x86_64-linux"; };
        nixpkgs-unstable = import nixpkgs-unstable { system = "x86_64-linux"; };

        imports = [
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
          disko.nixosModules.disko
          catppuccin.nixosModules.catppuccin
          lix-module.nixosModules.default
          ./nixos
        ];

        catppuccin-hm = catppuccin.homeManagerModules.catppuccin;
        nixgl = nixgl.packages.x86_64-linux;
      };

      packages = forAllSystems (
        system:
        let
          generate = nixos-dns.utils.generate nixpkgs.legacyPackages.${system};
          dnsConfig.extraConfig = import ./dns.nix;
        in
        {
          zoneFiles = generate.zoneFiles dnsConfig;
          octodns = generate.octodnsConfig {
            inherit dnsConfig;
            config.providers = {
              gcore = {
                class = "octodns_gcore.GCoreProvider";
                token = "env/GCORE_TOKEN";
              };
              config.check_origin = false;
            };
            zones = {
              "kitten.works." = inputs.nixos-dns.utils.octodns.generateZoneAttrs [ "gcore" ];
              "feline.works." = inputs.nixos-dns.utils.octodns.generateZoneAttrs [ "gcore" ];
              "theria.nl." = inputs.nixos-dns.utils.octodns.generateZoneAttrs [ "gcore" ];
            };
          };
        }
      );
    };
}
