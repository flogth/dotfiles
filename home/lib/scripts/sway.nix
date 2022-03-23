{ pkgs, ... }:
let
  screenshot = pkgs.writeShellApplication {
    name = "screenshot";
    runtimeInputs = with pkgs; [ grim slurp swappy ];
    text = ''
      opid=$(pgrep screenshot | wc -l)

      [ "$opid" -le 2 ] && grim -g "$(slurp)" - | swappy -f -
    '';
  };
in { home.packages = [ screenshot ]; }

