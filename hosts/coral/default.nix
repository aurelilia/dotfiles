{ ... }:
{
  imports = [ ./hardware.nix ];
  elia = {
    systemType = "workstation";
    mobile = true;
  };
}
