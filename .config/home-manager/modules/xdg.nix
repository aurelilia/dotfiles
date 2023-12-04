{ config, pkgs, ... }:
{
  home.sessionVariables = {
    LESSHISTFILE = "/dev/null";
    GRADLE_USER_HOME = "/ethereal/cache/gradle";
    CARGO_HOME = "/ethereal/cache/cargo";
    RUSTUP_HOME = "/ethereal/cache/rustup";
    GNUPGHOME = "/ethereal/cache/gnupg";
  };
}
