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
    interfaces = [ "enp5s0" "wlp4s0" ];
  };

  system.stateVersion = "21.05";
}
