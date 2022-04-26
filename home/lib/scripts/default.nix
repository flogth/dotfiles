{ pkgs, config, ... }: {
  imports = [ ./emacs.nix ./sway.nix ./ui.nix ./cli.nix ];
}
