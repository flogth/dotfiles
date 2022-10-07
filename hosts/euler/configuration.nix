{ ... }:

{
  imports = [ ../modules ./hardware-configuration.nix ];

  users.users.flo = {
    isNormalUser = true;
    initialPassword = "";
    extraGroups = [ "wheel" ];
  };

  local.network = {
    enable = true;
    hostName = "euler";
  };

  system.stateVersion = "21.05";
}
