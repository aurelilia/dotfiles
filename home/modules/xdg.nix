{ config, pkgs, lib, ... }:
{
  home.sessionVariables = {
    LESSHISTFILE = "/dev/null";
    
    GRADLE_USER_HOME = "/ethereal/cache/gradle";
    CARGO_HOME = "/ethereal/cache/cargo";
    RUSTUP_HOME = "/ethereal/cache/rustup";
    GNUPGHOME = "/ethereal/cache/gnupg";
    WINEPREFIX = "/ethereal/cache/wineprefix";

    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=\"$XDG_CONFIG_HOME\"/java";

    NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc"; 
  };

  xdg.configFile."npm/npmrc".text = ''
    prefix=/ethereal/cache/npm-prefix
    cache=/ethereal/cache/npm
    init-module=/ethereal/cache/npm/config/npm-init.js
  '';
  xdg.configFile."nix/nix.conf".text = ''
    use-xdg-base-directories = true
  '';
  home.activation.linkCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ln -sf /ethereal/cache/cache $HOME/.cache
  '';
}
