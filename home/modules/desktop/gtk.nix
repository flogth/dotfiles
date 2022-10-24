{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    capitaine-cursors
    glib
    gnome.gnome-themes-extra
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
    gtk2.extraConfig = ''
      gtk-cursor-theme-name="capitaine-cursors"
    '';
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-cursor-theme-name = "capitaine-cursors";
    };
    gtk4.extraConfig = { gtk-application-prefer-dark-theme = true; };
  };

  dconf.settings = with builtins;
    with pkgs.lib;
    let
      keybindings = [
        {
          name = "emacsclient";
          command = "${pkgs.emacsPgtkNativeComp}/bin/emacsclient -c";
          binding = "<Super>e";
        }
        {
          name = "terminal";
          command = "${pkgs.kgx}/bin/kgx";
          binding = "<Super>Return";
        }
      ];
      kbdId = i:
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${
          toString i
        }";
      kbdAttrs = listToAttrs (imap0 (n: kbd: {
        name = kbdId n;
        value = kbd;
      }) keybindings);
    in with lib.hm.gvariant;
    {
      "org/gnome/desktop/background" = let
        uri = "file:///${config.xdg.userDirs.pictures}/wallpapers/wallpaper";
      in {
        picture-uri = uri;
        picture-uri-dark = uri;
      };
      "org/gnome/desktop/input-sources" = {
        sources = [
          (mkTuple [ "xkb" "us+altgr-intl" ])
          (mkTuple [ "xkb" "de+nodeadkeys" ])
        ];
        xkb-options = [ "ctrl:nocaps" ];
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        cursor-theme = "capitaine-cursors";
        enable-hot-corners = false;
        show-battery-percentage = true;

        font-name = "Fira Sans 11";
        document-font-name = "Fira Sans 11";
        font-antialiasing = "rgba";

        # Stupid Gnome Console
        monospace-font-name = "JuliaMono 12";
      };
      "org/gnome/desktop/peripherals/touchpad" = { natural-scroll = false; };
      "org/gnome/desktop/sound" = {
        allow-volume-above-100-percent = true;
        event-sounds = false;
      };
      "org/gnome/desktop/wm/keybindings" = { close = [ "<Super>w" ]; };

      "org/gnome/desktop/wm/preferences" = {
        auto-raise = true;
        focus-new-windows = "strict";
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = imap0 (i: _: "/${kbdId i}/") keybindings;
      };
      "GWeather4" = { temperature-unit = "centigrade"; };
    } // kbdAttrs;
}
