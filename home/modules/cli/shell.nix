{ ... }: {
  programs.bash = {
    enable = true;
    shellAliases = {
      la = "ls -lAhF";
      scu = "systemctl --user";

      mv = "mv -vi";
      cp = "cp -i";
      rm = "rm -i";
      mkdir = "mkdir -v";
    };
    historyControl = [ "ignoredups" ];
    shellOptions = [ "autocd" "checkwinsize" ];
    bashrcExtra = ''
      if [ -n "$SSH_CONNECTION" ]; then
        export PS1="\h \[\e[1;34m\]\$\[\e[0m\] "
      else
        export PS1="\[\e[1;34m\]\$ \[\e[0m\]"
      fi
    '';
  };

  programs.readline = {
    enable = true;
    bindings = {
      "\\e[A" = "history-search-backward";
      "\\e[B" = "history-search-forward";
    };
  };
}
