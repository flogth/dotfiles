{ pkgs, ... }: {
  imports = [ ./gtk.nix ./xdg.nix ./work.nix ];

  home.packages = with pkgs; [
    inkscape
    gimp
    signal-desktop
    simple-scan
    mpv
    pika-backup
    newsflash
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
  };

  services.syncthing.enable = true;
}
