# Nix(OS) Configuration
This repository contains all my configurations done with Nix and NixOS,
packaged as a flake.

### Dotfiles
This includes my dotfiles, which are managed with `home-manager` and expect
either NixOS or Arch as a base. See `/home`; you'll likely want to import
either `server.nix` or `workstation.nix`, as this flake does.

Some more stuff is contained in `/home/misc`.

### Servers
My servers running NixOS are also configured out of this repository; currently
some are not migrated yet - work in progress!

I'm using the great `colmena` to deploy remotely. See `/fleet` for system
configuration.
