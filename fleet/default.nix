{ home-manager, nixpkgs, agenix, ... }:
{
  meta = {
    nixpkgs = import nixpkgs {
      system = "x86_64-linux";
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
    deployment.tags = [ "prod" "desktop" "laptop" ];
    imports = [ ../hosts/mauve ./workspace.nix ];
  };
}
