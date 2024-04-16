let
  sources = import ./npins;
  nixpkgs-unstable = import sources.nixpkgs-unstable { system = "x86_64-linux"; };
in
with sources;
((import ./nixos/entry.nix) {
  nixpkgs = import nixpkgs { system = "x86_64-linux"; };
  inherit nixpkgs-unstable;

  imports = [
    "${home-manager}/nixos"
    "${agenix}/modules/age.nix"
    "${disko}/module.nix"
    "${catppuccin}/modules/nixos"
    ./nixos
  ];

  catppuccin-hm = "${catppuccin}/modules/home-manager";
  nixgl = import nixgl { pkgs = nixpkgs-unstable; };
})
