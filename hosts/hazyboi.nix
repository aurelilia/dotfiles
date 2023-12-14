{ config, lib, pkgs, ... }: {
  dots.kind = "desktop";
  dots.base = "arch";
  imports = [ ../main.nix ../gui.nix ];
}
