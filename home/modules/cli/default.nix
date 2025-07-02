{ pkgs, ... }: {
  imports = [ ./shell.nix ];
  home.packages = with pkgs; [
    fd
    ripgrep
    ffmpeg
    file
    imagemagick
    ncdu

    nmap

    unzip
    zip
    rsync

    usbutils

    (hunspell.withDicts ([
      hunspellDicts.en-gb-ise
      hunspellDicts.en-us
      hunspellDicts.de-de
    ]))

    ghostscript
    groff

  ];

  programs = {
    texlive = {
      enable = true;
      extraPackages = tpkgs: { inherit (tpkgs) scheme-full; };
    };

    man.generateCaches = true;
  };
}
