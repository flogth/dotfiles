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
          command = "${pkgs.emacsPgtk}/bin/emacsclient -c";
          binding = "<Super>e";
        }
        {
          name = "terminal";
          command = "${pkgs.foot}/bin/foot";
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
        "org/gnome/desktop/input-sources" = {
          sources = [
            (mkTuple [ "xkb" "us+altgr-intl" ])
            (mkTuple [ "xkb" "de+nodeadkeys" ])
          ];
          xkb_options = [ "caps:escape" "grp:rctrl_toggle" ];
        };
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          cursor-theme = "capitaine-cursors";
          enable-hot-corners = false;
          show-battery-percentage = true;
        };
        "org/gnome/desktop/peripherals/touchpad" = { natural-scroll = false; };
        "org/gnome/desktop/sound" = { event-sounds = false; };
        "org/gnome/desktop/wm/keybindings" = { close = [ "<Super>w" ]; };


        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = imap0 (i: kbd: "/${kbdId i}/") keybindings;
        };
      } // kbdAttrs;
}
