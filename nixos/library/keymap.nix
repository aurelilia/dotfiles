{ ... }:
{
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          # Oneshot keys for modifiers
          shift = "oneshot(shift)";
          meta = "oneshot(meta)";
          control = "oneshot(control)";
          leftalt = "oneshot(alt)";
          rightalt = "oneshot(altgr)";

          # Minimak-8
          d = "t";
          e = "d";
          j = "n";
          k = "e";
          l = "o";
          n = "j";
          o = "l";
          t = "k";
        };
      };
    };
  };
}
