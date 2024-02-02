{ pkgs, ... }:
{
  programs.eww = {
    enable = true;
    # TODO Switch back to mainline EWW once they make a release,
    # 0.4.0 currently does not have some features related to windows
    # that make my configuration way less complex
    package = pkgs.eww-wayland.overrideDerivation (
      oldAttrs: {
        name = "eww-wayland-git";
        src = pkgs.fetchgit {
          url = "https://github.com/elkowar/eww.git";
          rev = "65d622c81f2e753f462d23121fa1939b0a84a3e0";
          hash = "sha256-MR91Ytt9Jf63dshn7LX64LWAVygbZgQYkcTIKhfVNXI=";
        };
      }
    );
    configDir = ../files/eww;
  };

  xdg.dataFile."fonts/material_design_iconic_font.ttf".source = ../files/material_design_iconic_font.ttf;
}
