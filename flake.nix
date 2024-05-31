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

    # TODO: s/release-24.05/nixos-24.05/ after release on 31.05.2024
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-oldstable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
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
      self,
      home-manager,
      nixpkgs,
      nixpkgs-oldstable,
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

      nixos-imports = {
        imports = [
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
          disko.nixosModules.disko
          catppuccin.nixosModules.catppuccin
          # lix-module.nixosModules.default
          nixos-dns.nixosModules.dns
          ./nixos
        ];

        _module.args = {
          pkgs-unstable = import nixpkgs-unstable { system = "x86_64-linux"; };
          pkgs-oldstable = import nixpkgs-oldstable { system = "x86_64-linux"; };
          catppuccin-hm = catppuccin.homeManagerModules.catppuccin;
          nixgl = nixgl.packages.x86_64-linux;
        };
      };
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

      colmena =
        (builtins.mapAttrs (name: host: {
          deployment.tags = host.tags;
          imports = [ ./hosts/${host.config or name} ];
        }) (import ./meta.nix).nodes)
        // {
          meta.nixpkgs = import nixpkgs { system = "x86_64-linux"; };

          defaults = nixos-imports // {
            deployment = {
              buildOnTarget = true;
              allowLocalDeployment = true;
            };
          };
        };

      packages = forAllSystems (
        system:
        let
          generate = nixos-dns.utils.generate nixpkgs.legacyPackages.${system};
          dnsConfig = {
            nixosConfigurations = (
              builtins.mapAttrs (
                name: host:
                nixpkgs.lib.nixosSystem {
                  system = "x86_64-linux";
                  modules = [
                    nixos-imports
                    ./hosts/${host.config or name}
                    { _module.args.name = name; }
                  ];
                }
              ) (import ./meta.nix).nodes
            );
            extraConfig = import ./dns.nix;
          };
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
