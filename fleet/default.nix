{ home-manager, nixpkgs, nixgl, agenix, ... }:
{
  meta = {
    nixpkgs = import nixpkgs {
      system = "x86_64-linux";
      overlays = [ nixgl.overlay ];
    };
  };

  defaults = { name, nodes, pkgs, ... }: {
    imports = [
      home-manager.nixosModules.home-manager
      agenix.nixosModules.default
      ./main.nix
    ];

    deployment.buildOnTarget = true;
  };

  navy = { name, nodes, pkgs, ... }: {
    deployment.tags = [ "prod" "server" ];
    imports = [ ../hosts/navy ./server.nix ];
  };

  jade = { name, nodes, pkgs, ... }: {
    deployment.tags = [ "prod" "server" "far" ];
    imports = [ ../hosts/jade ./server.nix ];
  };

  mauve = { name, nodes, pkgs, ... }: {
    deployment.tags = [ "prod" "workstation" "laptop" ];
    imports = [ ../hosts/mauve ./laptop.nix ];
  };
}
