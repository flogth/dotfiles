{ config, pkgs, ... }: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacsPgtkNativeComp;
  };
  services.emacs = {
    enable = true;
    package = pkgs.emacsPgtkNativeComp;
    client.enable = true;
    defaultEditor = true;
  };
  xdg.configFile = {
    "emacs/early-init.el".source = ../../config/emacs/early-init.el;
    "emacs/init.el".source = ../../config/emacs/init.el;
    "emacs/templates".source = ../../config/emacs/templates;
  };
}
