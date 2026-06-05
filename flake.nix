{
  description = "aurelila's full system configurations using Lix, NixOS, and HM";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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
    catppuccin.url = "github:catppuccin/nix/release-26.05";
    nixos-mail.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-26.05";
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
      nixpkgsHost = nixpkgs-unstable.legacyPackages.${hostSystem};
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
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
          inherit catppuccin;
          pkgs-unstable = nixpkgs-unstable.legacyPackages."x86_64-linux";
          nixgl = nixgl.packages.x86_64-linux;
        };
      };
    in
    {
      devShells.${hostSystem}.default = nixpkgsHost.mkShell {
        buildInputs = [
          nixpkgsHost.colmena
          agenix.packages.${hostSystem}.default
          nixpkgsHost.nixfmt
          (nixpkgsHost.octodns.withProviders (
            ps:
            with nixpkgsHost;
            with python3Packages;
            [
              octodns-providers.bind
              (buildPythonPackage rec {
                pname = "octodns-gcore";
                version = "1.0.0";
                pyproject = true;

                src = fetchFromGitHub {
                  owner = "octodns";
                  repo = "octodns-gcore";
                  rev = "f50c31c5886703396aab90ac6e6191dc6db5904c";
                  hash = "sha256-s/wiDSnmR/hfRKINgolEizk4m39cXLXrpvUCB7aw94w=";
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
          meta.nixpkgs = nixpkgs.legacyPackages."x86_64-linux";

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
              "catin.eu." = inputs.nixos-dns.utils.octodns.generateZoneAttrs [ "gcore" ];
            };
          };
        }
      );
    };
}
