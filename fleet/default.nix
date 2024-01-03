let
  haze-swarm = { name, nodes, pkgs, ... }: {
    deployment.tags = [ "prod" "server" "swarm" ];
    imports = [ ../hosts/haze-swarm ./server.nix ];
  };
in { home-manager, nixpkgs, nixgl, agenix, disko, ... }: {
  meta = {
    nixpkgs = import nixpkgs {
      system = "x86_64-linux";
    };
  };

  defaults = { name, nodes, pkgs, ... }: {
    imports = [
      home-manager.nixosModules.home-manager
      agenix.nixosModules.default
      disko.nixosModules.disko
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

  haze = { name, nodes, pkgs, ... }: {
    deployment.tags = [ "prod" "server" ];
    imports = [ ../hosts/haze ./server.nix ];
  };
  haze-swarm1 = haze-swarm;
  haze-swarm2 = haze-swarm;
  haze-swarm3 = haze-swarm;

  mauve = { name, nodes, pkgs, ... }: {
    deployment.tags = [ "prod" "workstation" "laptop" ];
    imports = [ ../hosts/mauve ./laptop.nix ];
  };
  coral = { name, nodes, pkgs, ... }: {
    deployment.tags = [ "prod" "workstation" "laptop" ];
    imports = [ ../hosts/coral ./laptop.nix ];
  };
  hazyboi = { name, nodes, pkgs, ... }: {
    deployment.tags = [ "prod" "workstation" ];
    imports = [ ../hosts/hazyboi ./workstation.nix ];
  };
}
