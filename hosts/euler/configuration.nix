{ config, pkgs, lib, home-manager, ... }:

{
  imports = [ ../modules ./hardware-configuration.nix ];

  users.users.flo = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  local.network = {
    enable = true;
    hostName = "euler";
    interfaces = [ "enp2s0" "wlp3s0" ];
  };

  system.stateVersion = "21.05";

}
