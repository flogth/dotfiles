{ config, pkgs, ... }: {

  programs.bash = {
    enable = true;
    shellAliases = {
      la = "ls -lAhF";
      mv = "mv -v";
      cp = "cp -i";
      scu = "systemctl --user";
      gst = "${pkgs.git}/bin/git status";
    };
    historyControl = [ "ignoredups" ];
    shellOptions = [ "autocd" "checkwinsize" ];
    bashrcExtra = ''
      export PS1="\[\e[0;37m\][\[\e[0;35m\]\w\[\e[0;37m\]] \[\e[0;32m\]?- \[\e[0m\]"
    '';
  };
  programs.readline = {
    enable = true;
    bindings = {
      "\\e[A" = "history-search-backward";
      "\\e[B" = "history-search-forward";
    };
  };
  programs.nnn = {
    enable = true;
    bookmarks = { u = "~/data/uni/lv"; };
  };
}
