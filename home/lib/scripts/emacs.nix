{ pkgs, ... }:
let
  magit = pkgs.writeShellApplication {
    name = "magit";
    runtimeInputs = [ pkgs.emacsPgtk ];
    text = ''
      emacsclient -r --eval "(magit)" &
      disown
    '';
  };
  edit = pkgs.writeShellApplication {
    name = "edit";
    runtimeInputs = [ pkgs.emacsPgtk ];
    text = ''
      emacsclient -r "$1" &
      disown
    '';
  };
in { home.packages = [ magit edit ]; }
