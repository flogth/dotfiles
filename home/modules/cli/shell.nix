{ config, pkgs, ... }: {

  programs.bash = {
    enable = true;
    shellAliases = {
      # convenience
      la = "ls -lAhF";
      scu = "systemctl --user";
      jcu = "journalctl --user";
      gst = "${pkgs.git}/bin/git status";

      # make commands more verbose
      mv = "mv -vi";
      cp = "cp -i";
      rm = "rm -i";
      mkdir = "mkdir -v";
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
  home.packages = with pkgs; [ nix-bash-completions ];
}
