{ config, pkgs, ... }: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [{
      height = 33;
      modules-left = [ "sway/workspaces" ];
      modules-center = [ "clock" ];
      modules-right =
        [ "idle_inhibitor" "pulseaudio" "network" "battery" "custom/powermenu" "tray" ];
      modules = {
        "battery" = {
          "states" = {
            "warning" = "20";
            "critical" = "5";
          };
          "format" = "{capacity}% {icon}";
          "format-charging" = "{capacity}% ";
          "format-plugged" = "{capacity}% ";
          "format-alt" = "{time} {icon}";
          "format-icons" = [ "" "" "" "" "" ];
        };
        "clock" = {
          "format" = "{:%H:%M} ";
          "format-alt" = "{:%Y-%m-%d} ";
          "tooltip-format" = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };

        "idle_inhibitor" = {
          "format" = "{icon}";
          "format-icons" = {
            "activated" = "";
            "deactivated" = "";
          };
        };
        "network" = {
          "format-wifi" = "";
          "format-ethernet" = "{ifname}: {ipaddr}/{cidr} ";
          "format-linked" = "{ifname} (No IP) ";
          "format-disconnected" = "⚠";
          "format-alt" = "{essid}/{ifname}: {ipaddr}";
        };
        "pulseaudio" = {
          "format" = "{volume}% {icon} {format_source}";
          "format-muted" = " {format_source}";
          "format-source" = "";
          "format-source-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [ "" "" "" ];
          };
          "on-click" = "pavucontrol";
        };
        "tray" = { "spacing" = 10; };
        "sway/workspaces" = {
          "disable-scroll" = true;
          "all-outputs" = true;
        };
        "custom/powermenu" = {
          "format" = "";
          "on-click" = "smenu";
        };
      };
    }];
    style = ''
      * {
        border: none;
        font-family: JuliaMono, sans-serif;
        font-size: 14px;
      }

      window#waybar {
        background-color: #12151d;
        opacity: 0.9;
        border-bottom: 3px solid #1e222a;
        color: #abb2bf;
        transition-property: background-color;
        transition-duration: .5s;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #workspaces,
      #clock,
      #idle_inhibitor,
      #pulseaudio,
      #battery,
      #network,
      #tray,
      #custom-powermenu
       {
        background-color: #1e222a;
        padding: 0 10px;
        margin: 2px 4px 5px 4px;
        border: 3px solid rgba(0, 0, 0, 0);
        border-radius: 90px;
        background-clip: padding-box;
       }

      #workspaces button {
        padding: 0 5px;
        min-width: 20px;
        color: #61afef;
      }

      #workspaces button:hover {
        background-color: rgba(0, 0, 0, 0.2)
      }

      #workspaces button.focused {
        color: #c678dd;
      }

      #workspaces button.urgent {
        color: #e06c75;
      }

      #clock {
        color: #61afef;
      }

      #idle_inhibitor {
        color: #abb2bf;
      }

      #idle_inhibitor.activated {
        background-color: #abb2bf;
        color: #1e222a;
      }

      #pulseaudio {
        color: #d19a66;
      }

      #pulseaudio.muted {
        background-color: #e06c75;
        color: #1e222a;
      }

      #battery {
        color: #98c379;
      }

      #battery.charging, #battery.plugged {
        background-color: #98c379;
        color: #1e222a;
      }

      @keyframes blink {
          to {
              background-color: #1e222a;
              color: #e06c75;
          }
      }

      #battery.critical:not(.charging) {
          background-color: #e06c75;
          color: #1e222a;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #network {
          color: #c678dd;
      }

      #network.disconnected {
          background-color: #e06c75;
          color: #1e222a;
      }
      #custom-powermenu {
          color: #e06c75;
      }
                            '';
  };
}
