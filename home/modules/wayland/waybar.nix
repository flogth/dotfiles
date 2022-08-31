{ pkgs, ... }: {
  programs.waybar = {
    enable = false;
    systemd.enable = true;
    settings = [{
      height = 33;
      modules-left = [ "sway/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [
        "custom/media"
        "custom/layout"
        "idle_inhibitor"
        "pulseaudio"
        "network"
        "custom/vpn"
        "battery"
        "custom/powermenu"
        "tray"
      ];
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
          "on-click" = "audiomenu";
          "on-click-middle" = "pavucontrol";
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
        "custom/vpn" = {
          "format" = "{icon} {}";
          "tooltip-format" = "{icon}";
          "exec" = "vpn status";
          "return-type" = "json";
          "interval" = 5;
          "format-icons" = [ "" "" ];
          "on-click" = "vpn toggle";
        };
        "custom/media" = {
          "format" = "{icon} {}";
          "tooltip-format" = "{}";
          "format-icons" = "";
          "escape" = true;
          "max-length" = 40;
          "exec-if" =
            ''[ $(${pkgs.playerctl}/bin/playerctl status) = "Playing" ]'';
          "exec" = ''
            ${pkgs.playerctl}/bin/playerctl metadata -F -f "{{title}} : {{artist}}"'';
        };
        "custom/layout" = {
          "format" = " {}";
          "format-alt" = " {} {icon}";
          "tooltip-format" = "rctrl to toggle";
          "format-icons" = [ "🇪🇺" "🇩🇪" ];
          "return-type" = "json";
          "interval" = 5;
          "exec" = "layout";
          "on-click-middle" =
            "${pkgs.imv}/bin/imv -b ffffff $XDG_PICTURES_DIR/layout.png";
        };
      };
    }];
    style = let
      colors = {
        bg = "#12151d";
        fg = "#abb2bf";
        modules = { bg = "#1e222a"; };
        blue = "#61afef";
        green = "#2ec27e";
        orange = "#ffa348";
        purple = "#c678dd";
        red = "#e06c75";
      };
    in ''
        * {
          border: none;
          font-family: JuliaMono, sans-serif;
          font-size: 14px;
        }

        window#waybar {
          background-color: alpha(${colors.bg},0.8);
          color: ${colors.fg};
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
        #custom-powermenu,
        #custom-vpn,
        #custom-media,
        #custom-layout
         {
          background-color: ${colors.modules.bg};
          padding: 0 10px;
          margin: 2px 4px 5px 4px;
          border: 3px solid rgba(0, 0, 0, 0);
          border-radius: 90px;
          background-clip: padding-box;
         }

        #workspaces button {
          padding: 0 5px;
          min-width: 20px;
          color: ${colors.blue};
        }

        #workspaces button:hover {
          background-color: rgba(0, 0, 0, 0.2)
        }

        #workspaces button.focused {
          color: ${colors.purple};
        }

        #workspaces button.urgent {
          color: ${colors.red};
        }

        #clock {
          color: ${colors.blue};
        }

        #idle_inhibitor.activated {
          background-color: ${colors.fg};
          color: ${colors.modules.bg};
        }

        #pulseaudio {
          color: ${colors.orange};
        }

        #pulseaudio.muted {
          background-color: ${colors.red};
          color: ${colors.modules.bg};
        }

        #battery {
          color: ${colors.green};
        }

        #battery.charging, #battery.plugged {
          background-color: ${colors.green};
          color: ${colors.modules.bg};
        }

        @keyframes blink {
            to {
                background-color: ${colors.modules.bg};
                color: ${colors.red};
            }
        }

        #battery.critical:not(.charging) {
            background-color: ${colors.red};
            color: ${colors.modules.bg};
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        #network {
            color: ${colors.purple};
        }

        #network.disconnected {
            background-color: ${colors.red};
            color: ${colors.modules.bg};
        }

        #custom-powermenu {
            color: ${colors.red};
        }
        #custom-vpn.connected {
          color: ${colors.green};
        }
      #custom-media {
          color: ${colors.green};
      }
    '';
  };
}
