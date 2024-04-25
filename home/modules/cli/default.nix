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

    (hunspellWithDicts ([hunspellDicts.en-us hunspellDicts.de-de]))

    ghostscript

  ];
  programs = {
    texlive = {
      enable = true;
      extraPackages = tpkgs: { inherit (tpkgs) scheme-full; };
    };
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
