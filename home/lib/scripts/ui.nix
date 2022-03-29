{ pkgs, ... }:
let
  smenu = pkgs.writeShellApplication {
    name = "smenu";
    runtimeInputs = with pkgs; [ wofi libnotify ];
    text = ''
      action=$(printf "shutdown\nsuspend\nreboot" | wofi --dmenu --prompt "smenu" -c "$XDG_CONFIG_HOME/wofi/menu.config" -H 10%)
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
  audiomenu = pkgs.writeShellApplication {
    name = "audiomenu";
    runtimeInputs = with pkgs; [ wofi pamixer wireplumber ];
    text = ''
    sinks="$(pamixer --list-sinks | cut -s -f 3- -d ' ' | sed 's/\"//g')"
    select="$(echo "$sinks" | wofi --dmenu -c "$XDG_CONFIG_HOME/wofi/menu.config" -l center -W 50%)"
    select_id="$(pamixer --list-sinks | grep "$select" | cut -c 1-2)"
    wpctl set-default "$select_id"
    '';
  };
in { home.packages = [ smenu audiomenu ]; }
