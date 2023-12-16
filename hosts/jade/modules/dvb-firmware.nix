{ pkgs, ... }:
{
  hardware.firmware = [
    (pkgs.stdenvNoCC.mkDerivation {
      name = "m88rs6000-firmware";
      buildCommand = ''
        cp -r ${./dvb-demod-m88rs6000.fw} "$out"
      ''
    })
  ];
}