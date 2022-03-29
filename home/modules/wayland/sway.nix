{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    brightnessctl # control screen brightness
    grim # screenshot
    imv # image viewer
    pamixer # pulseaudio/pipewire control
    playerctl
    pinentry-gnome
    polkit_gnome
    slurp # select area on screen
    swappy # edit screenshots
    swayidle
    swaylock-effects
    wl-clipboard
    wofi # launcher
    wob # progress bars
    xdg-desktop-portal-wlr # pipewire media session
    xdg-user-dirs
  ];

  services.swayidle = {
    enable = true;
    events = [{
      event = "before-sleep";
      command = "${pkgs.swaylock-effects}/bin/swaylock -f";
    }];
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock-effects}/bin/swaylock -f";
      }
      {
        timeout = 600;
        command = ''swaymsg output "*" dpms off'';
        resumeCommand = ''swaymsg output "" dpms on'';
      }
    ];
  };

  wayland.windowManager.sway = let
    audiosock = "$XDG_RUNTIME_DIR/wob-audio.sock";
    brightnesssock = "$XDG_RUNTIME_DIR/wob-brightness.sock";
    mod = "Mod4";
  in {
    enable = true;
    systemdIntegration = true;
    extraSessionCommands = "dbus-update-activation-environment DISPLAY";
    wrapperFeatures = {
      base = true;
      gtk = true;
    };

    config = {
      gaps = {
        inner = 5;
        outer = 5;
        smartGaps = true;
        smartBorders = "no_gaps";
      };

      input = {
        "*" = {
          xkb_layout = "de";
          xkb_variant = "nodeadkeys";
          xkb_options = "caps:escape,compose:rctrl";
        };
      };
      output = {
        "*" = { bg = "$HOME/data/pictures/wallpapers/wallpaper fill"; };
      };
      seat = { "*" = { hide_cursor = "when-typing enable"; }; };
      modifier = mod;
      floating.modifier = mod;
      terminal = "${pkgs.foot}/bin/foot";
      startup = [{
        command = "dbus-update-activation-environment DISPLAY";
        always = true;
      }];

      window.commands = [
        # firefox PiP-windows
        {
          criteria = {
            app_id = "firefox";
            title = "^Picture-in-Picture$";
          };
          command = "floating enable";
        }
        # firefox sharing indicator
        {
          criteria = {
            app_id = "firefox";
            title = "^Firefox — Sharing Indicator$";
          };
          command = "floating enable";
        }
        # floating terminal window
        {
          criteria = {
            app_id = "foot";
            title = "scratchpad";
          };
          command = "floating enable, opacity 0.9";
        }
        # image viewer
        {
          criteria = { app_id = "imv"; };
          command = "floating enable";
        }
        # file manager
        {
          criteria = { app_id = "org.gnome.Nautilus"; };
          command = "floating enable";
        }
        {
          criteria = { title = "Steam - News.*"; };
          command = "kill";
        }

        {
          criteria = { app_id = "pavucontrol"; };
          command = "floating enable";
        }
      ];

      keybindings = with pkgs.lib;
        let
          ws = [ "1:" "2:" ] ++ map toString (range 3 9);
          indexed_ws = zipLists (map toString (range 1 9)) ws;
          wskeys = foldl (a: b: a // b) { } (map (e: {
            "${mod}+${e.fst}" = "workspace ${e.snd}";
            "${mod}+Shift+${e.fst}" = "move container to workspace ${e.snd}";
          }) indexed_ws);

          # wskeys = pkgs.lib.foldl (a: b: a // b) { }
          #   (map (i: {
          #     "${mod}+${i}" = "workspace ${i}";
          #     "${mod}+Shift+${i}" = "move container to workspace ${i}";
          #   }) ws);
        in wskeys // {
          "${mod}+Return" = "exec foot";
          "${mod}+Shift+Return" = "exec foot -T scratchpad";
          "${mod}+e" = "exec emacsclient -c";
          "${mod}+b" = "exec firefox";
          "${mod}+Space" = "exec wofi -c $XDG_CONFIG_HOME/wofi/base.config";
          "${mod}+Escape" = "exec smenu";
          "${mod}+Alt+Space" = "exec nautilus";

          "${mod}+w" = "kill";
          "${mod}+f" = "fullscreen";
          "${mod}+Shift+f" = "floating toggle";
          "${mod}+Shift+t" = "layout toggle tabbed split";
          "${mod}+Shift+s" = "sticky toggle";
          "${mod}+Shift+h" = "resize shrink width 10px";
          "${mod}+Shift+l" = "resize grow width 10px";
          "${mod}+Shift+j" = "resize shrink height 10px";
          "${mod}+Shift+k" = "resize grow height 10px";

          "${mod}+Tab" = "workspace back_and_forth";
          "XF86Display" = "move workspace to output right";
          "${mod}+Shift+Right" = "move workspace to output right";
          "${mod}+Shift+Left" = "move workspace to output left";

          "XF86AudioRaiseVolume" =
            "exec pamixer --allow-boost -ui 2 && pamixer --get-volume > ${audiosock} ";
          "XF86AudioLowerVolume" =
            "exec pamixer --allow-boost -ud 2 && pamixer --get-volume > ${audiosock} ";
          "XF86AudioMute" =
            "exec pamixer -t && ( pamixer --get-mute && echo 0 > ${audiosock} ) || pamixer --get-volume > ${audiosock}";
          "XF86AudioMicMute" =
            "exec pamixer --source $(pamixer --list-sources | awk '(NR>2) {print $1}') -t";

          "XF86MonBrightnessUp" =
            "exec brightnessctl s +5% && brightnessctl g > ${brightnesssock}";
          "XF86MonBrightnessDown" =
            "exec brightnessctl s 5%- && brightnessctl g  > ${brightnesssock}";
          "Print" = "exec screenshot";

        };
      bars = [];
    };

  };
}
