{ ... }:

{
  imports = [ ../modules ./hardware-configuration.nix ];

  users.users.flo = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  local.network = {
    enable = true;
    hostName = "zuse";
  };

  system.stateVersion = "21.05";
}
