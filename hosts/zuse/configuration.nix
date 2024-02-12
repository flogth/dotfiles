{ ... }:

{
  imports = [ ../modules ./hardware-configuration.nix ];

  users.users.flo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
  };

  programs.steam.enable = true;

  local.network = {
    enable = true;
    hostName = "zuse";
  };

  system.stateVersion = "21.05";
}
