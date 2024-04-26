{ ... }:
{
  imports = [
    ./hardware.nix
    ./disko.nix
  ];
  feline.archetype = "generic";
}
