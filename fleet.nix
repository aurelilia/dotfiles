let
  mkHost =
    { name, tag }:
    args: {
      deployment.tags = [ tag ];
      imports = [ ./hosts/${name} ];
    };
  haze-swarm = mkHost {
    name = "haze-swarm";
    tag = "swarm";
  };
in
{
  home-manager,
  nixpkgs,
  nixpkgs-unstable,
  nixpkgs-streamrip,
  agenix,
  disko,
  nixgl,
  ...
}:
{
  meta = {
    nixpkgs = import nixpkgs { system = "x86_64-linux"; };
  };

  defaults = args: {
    imports = [
      home-manager.nixosModules.home-manager
      agenix.nixosModules.default
      disko.nixosModules.disko
      ./nixos
    ];

    _module.args = {
      pkgs-unstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        overlays = [ nixgl.overlay ];
      };
      pkgs-streamrip = import nixpkgs-streamrip { system = "x86_64-linux"; };
    };

    deployment = {
      buildOnTarget = true;
      allowLocalDeployment = true;
    };
  };

  navy = mkHost {
    name = "navy";
    tag = "server";
  };
  jade = mkHost {
    name = "jade";
    tag = "server";
  };
  haze = mkHost {
    name = "haze";
    tag = "server";
  };
  haze-swarm1 = haze-swarm;
  haze-swarm2 = haze-swarm;
  haze-swarm3 = haze-swarm;

  mauve = mkHost {
    name = "mauve";
    tag = "workstation";
  };
  coral = mkHost {
    name = "coral";
    tag = "workstation";
  };
  hazyboi = mkHost {
    name = "hazyboi";
    tag = "workstation";
  };
}
