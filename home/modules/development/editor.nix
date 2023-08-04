{ pkgs, ... }:
let
  local-emacs = (pkgs.emacsPackagesFor pkgs.emacs29-pgtk).emacsWithPackages
    (epkgs: [ epkgs.treesit-grammars.with-all-grammars ]);
in
{
  programs.emacs = {
    enable = true;
    package = local-emacs;
  };
  services.emacs = {
    enable = true;
    package = local-emacs;
    client.enable = true;
    defaultEditor = true;
  };
  xdg.configFile = {
    "emacs/early-init.el".source = ../../config/emacs/early-init.el;
    "emacs/init.el".source = ../../config/emacs/init.el;
  };
}
