{
  home-manager,
  nixpkgs,
  nixpkgs-unstable,
  agenix,
  disko,
  nixgl,
  microvm,
  catppuccin,
  ...
}:
(builtins.mapAttrs (name: host: {
  deployment.tags = [ host.tag ];
  imports = [ ./hosts/${host.config or name} ];
}) (import ./meta.nix).nodes)
// {
  meta = {
    nixpkgs = import nixpkgs { system = "x86_64-linux"; };
    nodeNixpkgs.haze = import nixpkgs-unstable { system = "x86_64-linux"; };
  };

  defaults = args: {
    imports = [
      home-manager.nixosModules.home-manager
      agenix.nixosModules.default
      disko.nixosModules.disko
      microvm.nixosModules.host
      catppuccin.nixosModules.catppuccin
      ./nixos
    ];

    _module.args = {
      inherit catppuccin;
      pkgs-unstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        overlays = [ nixgl.overlay ];
      };
    };

    deployment = {
      buildOnTarget = true;
      allowLocalDeployment = true;
    };
  };
}
