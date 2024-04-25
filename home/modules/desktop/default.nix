{ pkgs, ... }:

{
  imports = [ ./gtk.nix ./xdg.nix ./work.nix ];
  home.packages = with pkgs; [
    inkscape
    gimp
    signal-desktop
    simple-scan
    mpv
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
  };

  services.syncthing.enable = true;
}
