{ pkgs, ... }: {
  imports = [ ./shell.nix ];
  home.packages = with pkgs; [
    fd # better find
    ripgrep # better grep
    ffmpeg # everything video
    file # info about a file
    imagemagick

    nmap
    magic-wormhole

    unzip
    zip
    rsync

    usbutils

    hunspell
    hunspellDicts.de-de
    hunspellDicts.en-us

    libnotify # notify-send

    graphviz

    man-pages
  ];
  programs = {
    htop = {
      enable = true;
      settings = {
        show_program_path = 0;
        highlight_base_name = 1;
      };
    };
    man.generateCaches = true;
  };
}
