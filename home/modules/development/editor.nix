{ config, pkgs, ... }: {
  systemd.user.sessionVariables = {
    EDITOR = "emacsclient -nw";
    VISUAL = "emacsclient -r";
  };
  home.packages = with pkgs; [ emacsPgtkNativeComp ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode-fhs;
  };
  services.emacs = {
    enable = true;
    package = pkgs.emacsPgtkNativeComp;
  };
  xdg.configFile = {
    "emacs/early-init.el".source = ../../config/emacs/early-init.el;
    "emacs/init.el".source = ../../config/emacs/init.el;
    "emacs/templates".source = ../../config/emacs/templates;
  };
}
