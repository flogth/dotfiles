{ config, pkgs, lib, ... }:
let
  username = "flo";
in {
  imports = [
    ../modules/wayland
    ../modules/desktop
    ../modules/development
    ../modules/cli
    ../lib/scripts
  ];
  home.packages = with pkgs;
    [
      openvpn
      qemu
    ];
    programs.home-manager.enable = true;
}
