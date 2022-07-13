{ pkgs, lib, args, ... }: {
  imports = [
    ./modules/wayland
    ./modules/desktop
    ./modules/development
    ./modules/cli
    ./lib/scripts
  ];
  home.packages = [ pkgs.cachix ];
  home.stateVersion = "21.05";
  local = args;
}
