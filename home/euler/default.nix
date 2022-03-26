{ config, pkgs, lib, cachix, ... }:
let username = "flo";

in {
  caches = {
    cachix = [{
      name = "nix-community";
      sha256 = "00lpx4znr4dd0cc4w4q8fl97bdp7q19z1d3p50hcfxy26jz5g21g";
    }];
  };
  imports = [
    ../modules/wayland
    ../modules/desktop
    ../modules/development
    ../modules/cli
    ../lib/scripts
  ];
  local = {
    terminal = {
      enable = true;
      fontSize = 10;
    };
  };
  programs.home-manager.enable = true;
  home.packages = [ pkgs.cachix ];
}
