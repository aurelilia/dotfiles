{ config, lib, ... }:
{
  home.sessionVariables = {
    LESSHISTFILE = "/dev/null";

    GRADLE_USER_HOME = "/ethereal/cache/gradle";
    CARGO_HOME = "/ethereal/cache/cargo";
    CARGO_TARGET_DIR = "/ethereal/cache/rust-target";
    GNUPGHOME = "/ethereal/cache/gnupg";
    WINEPREFIX = "/ethereal/cache/wineprefix";

    _JAVA_OPTIONS = ''-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java'';
    NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
  };

  xdg = {
    configFile = {
      "npm/npmrc".text = ''
        prefix=/ethereal/cache/npm-prefix
        cache=/ethereal/cache/npm
        init-module=/ethereal/cache/npm/config/npm-init.js
      '';
      "nix/nix.conf".text = ''
        use-xdg-base-directories = true
      '';
    };

    mime.enable = true;
    userDirs = {
      enable = true;
      download = "${config.home.homeDirectory}/download";
      music = "${config.home.homeDirectory}/personal/music";
      pictures = "${config.home.homeDirectory}/personal/images";
    };
  };

  home.activation.linkCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    rm -rf $HOME/.cache
    ln -sf /ethereal/cache/xdg $HOME/.cache
  '';
}
