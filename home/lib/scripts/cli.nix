{ pkgs, ... }:
let
  ex = pkgs.writeShellApplication {
    name = "ex";
    runtimeInputs = with pkgs; [ gnutar bzip2 ];
    text = ''
      if [ -f "$1" ]; then
        case "$1" in
          *.tar) tar xf "$1";;
          *tar.bz2 | *.tbz2) tar xjvf "$1";;
          *.tar.gz | *.tgz) tar xzvf "$1";;
          *.bz2) bunzip2 "$1";;
          *.gz) gunzip "$1";;
          *.zip) unzip "$1";;
          *) echo "$1 cannot be extracted via ex";;
         esac
       fi'';
  };
  # adapted from Henrik Lissners dotfiles
  # https://github.com/hlissner/dotfiles/blob/master/bin/optimpdf
  optipdf = pkgs.writeShellApplication {
    name = "optipdf";
    runtimeInputs = with pkgs; [ ghostscript ];
    text = ''
      function filesize() {
        stat -c %s "$1" | numfmt --to=iec
      }

      src="$1"
      dest="''${2:--}"
      gs -q -dNOPAUSE -dBATCH -dSAFER \
        -sDEVICE=pdfwrite \
        -dPDFSETTINGS=/screen \
        -dCompatibilityLevel=1.3 \
        -dEmbedAllFonts=true \
        -dSubsetFonts=true \
        -dAutoRotatePages=/None \
        -dMonoImageResolution=72 \
        -dMonoImageDownsampleType=/Bicubic \
        -dGrayImageResolution=72 \
        -dGrayImageDownsampleType=/Bicubic \
        -dColorImageResolution=72 \
        -dColorImageDownsampleType=/Bicubic \
        -sOutputFile="$dest" \
        "$src"

        printf "%-32s%-8s\n" "$src" "$(filesize "$src")" 
        printf "%-32s%-8s\n" "$dest" "$(filesize "$dest")" 
    '';
  };
in { home.packages = [ ex optipdf ]; }
