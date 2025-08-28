{
  description = "aurelila's full system configurations using Lix, NixOS, and HM";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
    nixos-mail.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
  };

  outputs =
    inputs@{
      self,
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
      agenix,
      disko,
      nixgl,
      nixos-dns,
      nixos-mail,
      catppuccin,
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
          nixos-dns.nixosModules.dns
          nixos-mail.nixosModules.default
          ./nixos
        ];

        _module.args = {
          pkgs-unstable = import nixpkgs-unstable { system = "x86_64-linux"; };
          catppuccin-hm = catppuccin.homeModules.catppuccin;
          nixgl = nixgl.packages.x86_64-linux;
        };
      };
    in
    {
      devShells.${hostSystem}.default = nixpkgsHost.mkShell {
        buildInputs = [
          (nixpkgsHost.colmena.override { nix = nixpkgsHost.lix; })
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
                    {
                      _module.args.name = name;
                      feline.dns.enable = true;
                    }
                    nixos-imports
                    ./hosts/${host.config or name}
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
              "ehir.art." = inputs.nixos-dns.utils.octodns.generateZoneAttrs [ "gcore" ];
              "tessa.dog." = inputs.nixos-dns.utils.octodns.generateZoneAttrs [ "gcore" ];
              "catin.eu." = inputs.nixos-dns.utils.octodns.generateZoneAttrs [ "gcore" ];
            };
          };
        }
      );
    };
}
