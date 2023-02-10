{ pkgs, ... }:

{
  imports = [ ./games.nix ./gtk.nix ./xdg.nix ./terminal.nix ./work.nix ./firefox.nix ];
  home.packages = with pkgs; [
    inkscape # vector image editor
    signal-desktop # messenger
    simple-scan # scanning frontend
    mpv
  ];

  programs = {
    texlive = {
      enable = true;
      extraPackages = tpkgs: { inherit (tpkgs) scheme-full; };
    };
  };

  services = {
    udiskie = {
      enable = true;
      automount = false;
      tray = "never";
    };
    syncthing.enable = true;
  };
}
