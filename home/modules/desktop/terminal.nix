{ config, pkgs, ... }: {

  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "JuliaMono:size=10";
        dpi-aware = "yes";
      };
      csd = { preferred = "none"; };
      colors = {
        foreground = "f8f8f2";
        background = "282a36";
        regular0 = "222222";
        regular1 = "ff5555";
        regular2 = "50fa7b";
        regular3 = "f1fa8c";
        regular4 = "bd93f9";
        regular5 = "ff79c6";
        regular6 = "8be9fd";
        regular7 = "bfbfbf";
        bright0 = "666666";
        bright1 = "dca3a3";
        bright2 = "bfebbf";
        bright3 = "f0dfaf";
        bright4 = "8cd0d3";
        bright5 = "fcace3";
        bright6 = "b3ffff";
        bright7 = "ffffff";
      };
    };
  };
}
