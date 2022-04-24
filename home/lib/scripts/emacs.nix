{ pkgs, ... }:
let
  magit = pkgs.writeShellApplication {
    name = "magit";
    runtimeInputs = [ pkgs.emacsPgtkNativeComp ];
    text = ''
      emacsclient -r --eval "(magit)" &
      disown
    '';
  };
  edit = pkgs.writeShellApplication {
    name = "edit";
    runtimeInputs = [ pkgs.emacsPgtkNativeComp ];
    text = ''
      emacsclient -r "$1" &
      disown
    '';
  };
in { home.packages = [ magit edit ]; }
