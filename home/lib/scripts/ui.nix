{ pkgs, ... }:
let
  smenu = pkgs.writeShellApplication {
    name = "smenu";
    runtimeInputs = with pkgs; [ wofi libnotify ];
    text = ''
      action=$(printf "shutdown\nsuspend\nreboot" | wofi --dmenu --prompt "smenu")
      case $action in
          shutdown)
              shutdown now
              ;;
          suspend)
              systemctl suspend
              ;;
          reboot)
              reboot
              ;;
          *)
              notify-send "smenu" "error matching action"
      esac
          '';
  };
in { home.packages = [ smenu ]; }
