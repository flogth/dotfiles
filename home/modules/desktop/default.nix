{ pkgs, ... }:

{
  imports = [ ./games.nix ./gtk.nix ./xdg.nix ./terminal.nix ./work.nix ./firefox.nix ];
  home.packages = with pkgs; [
    inkscape # vector image editor
    signal-desktop # messenger
    simple-scan # scanning frontend
    mpv
    calibre
  ];

  programs = {
    texlive = {
      enable = true;
      extraPackages = tpkgs: { inherit (tpkgs) scheme-full; };
    };

    zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
        guioptions = "svh";
        font = "JuliaMono 12";
        statusbar-bg = "#6f18f2";
        default-bg = "#282a36";
        window-title-basename = true;
      };
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
