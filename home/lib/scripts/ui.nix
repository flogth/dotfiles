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

  vpn = pkgs.writeShellApplication {
    name = "vpn";
    runtimeInputs = with pkgs; [ systemd wofi ];
    text = ''
      work_status() {
          [ "$(systemctl is-active openvpn-work)" = "active" ] && printf '{"text": "work", "class": "connected", "percentage": 100}'
      }

      work_toggle() {
          if work_status; then
              systemctl stop openvpn-work
          else
              systemctl start openvpn-work
          fi
      }

      uni_status() {
          [ "$(systemctl is-active openvpn-uni)" = "active" ] && printf '{"text": "uni", "class": "connected", "percentage": 100}'
      }

      uni_toggle() {
          if uni_status; then
              systemctl stop openvpn-uni
          else
              systemctl start openvpn-uni
          fi
      }

      disconnected_status(){
          printf '{"text": "", "class": "disconnected", "percentage":0}'
      }

      case "$1" in
          "status")
              work_status || uni_status || disconnected_status
              ;;
          "toggle")
              case "$(printf "work\nuni" | wofi --dmenu -c "$XDG_CONFIG_HOME/wofi/menu.config" -l center -W 50%)" in
                  "work")
                      work_toggle
                      ;;
                  "uni")
                      uni_toggle
                      ;;
                  *)
                      printf "no match"
                      ;;
              esac
              ;;
          *)
              printf "not matched"
              ;;
      esac
    '';
  };
  layout = pkgs.writeShellApplication {
    name = "layout";
    runtimeInputs = [ pkgs.sway pkgs.jq ];
    text = ''
          l="$(swaymsg -t get_inputs | jq -r 'first(.[] | select(has("xkb_active_layout_name"))) | .xkb_active_layout_name' | cut -d " " -f1)"
      case $l in
          English)
              p="0"
              n="en";;
          German)
              p="100"
              n="de";;
      esac
      printf '{"text": "%s", "percentage": %s}' "$n" "$p"
    '';

  };
in { home.packages = [ smenu audiomenu vpn layout ]; }
