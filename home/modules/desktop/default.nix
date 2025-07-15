{ pkgs, ... }: {
  imports = [ ./gtk.nix ./xdg.nix ./work.nix ];

  home.packages = with pkgs; [
    inkscape
    gimp
    signal-desktop-bin
    simple-scan
    mpv
    pika-backup
    newsflash
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
  };

  services.syncthing.enable = true;
}
