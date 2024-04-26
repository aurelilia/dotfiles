{ ... }:
{
  imports = [ ./hardware.nix ];
  feline = {
    systemType = "workstation";
    mobile = true;
  };
}
