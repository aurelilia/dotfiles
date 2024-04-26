{ ... }:
{
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
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
