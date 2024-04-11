{ pkgs, ... }: {
  imports = [ ./shell.nix ];
  home.packages = with pkgs; [
    fd # better find
    ripgrep # better grep
    ffmpeg # everything video
    file # info about a file
    imagemagick
    ncdu

    nmap

    unzip
    zip
    rsync

    usbutils

    (hunspellWithDicts ([hunspellDicts.en-us hunspellDicts.de-de]))

    libnotify # notify-send

    graphviz
    ghostscript

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
