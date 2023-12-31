# Nix(OS) Configuration
This repository contains all my configurations done with Nix and NixOS,
packaged as a flake.

### Dotfiles
This includes my dotfiles, which are managed with `home-manager` and expect
NixOS as a base. See `/home`; you'll likely want to import
either `server.nix` or `workstation.nix`, as this flake does.

### NixOS
My systems running NixOS are also configured out of this repository; currently
some are not migrated yet - work in progress!

I'm using the great `colmena` to deploy remotely. See `/fleet` for system
configuration.

For deploying an initial configuration from another Linux or the NixOS
installer, see `utils/deploy-*.sh`.

```
./utils/deploy-disko.sh <entry in hosts/; must contain disko.nix> <hostname>
./utils/deploy-prepartitioned.sh <hostname>
```

### Formatting
Using `nixfmt`.
