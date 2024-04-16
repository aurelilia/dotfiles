{
  nixpkgs,
  nixpkgs-unstable,
  catppuccin-hm,
  nixgl,
  imports,
  ...
}:
(builtins.mapAttrs (name: host: {
  deployment.tags = [ host.tag ];
  imports = [ ../hosts/${host.config or name} ];
}) (import ../meta.nix).nodes)
// {
  meta.nixpkgs = nixpkgs;

  defaults = args: {
    inherit imports;

    _module.args = {
      inherit catppuccin-hm nixgl;
      pkgs-unstable = nixpkgs-unstable;
    };

    deployment = {
      buildOnTarget = true;
      allowLocalDeployment = true;
    };
  };
}
