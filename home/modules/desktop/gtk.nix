{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    capitaine-cursors
    glib
    gnome-themes-extra
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
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
          command = "emacsclient -c";
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
      recursiveUpdate kbdAttrs
    {
      "org/gnome/desktop/input-sources" = {
        sources = [
          (mkTuple [ "xkb" "eu" ])
        ];
        xkb-options = [ "ctrl:nocaps" ];
        show-all-sources = true;
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        cursor-theme = "capitaine-cursors";
        enable-hot-corners = false;
        show-battery-percentage = true;

        font-name = "Fira Sans 11";
        document-font-name = "Fira Sans 11";
        font-antialiasing = "rgba";

        gtk-key-theme = "Emacs";

        # Stupid Gnome Console
        monospace-font-name = "JuliaMono 12";
      };
      "org/gnome/desktop/peripherals/touchpad" = { natural-scroll = false; };
      "org/gnome/desktop/sound" = {
        allow-volume-above-100-percent = true;
        event-sounds = false;
      };
      "org/gnome/desktop/wm/keybindings" = {
        close = [ "<Super>w" ];
        switch-to-workspace-1 = [ "<Super>1"];
        switch-to-workspace-2 = [ "<Super>2"];
        switch-to-workspace-3 = [ "<Super>3"];
        switch-to-workspace-4 = [ "<Super>4"];
      };

      "org/gnome/desktop/wm/preferences" = {
        auto-raise = true;
        focus-new-windows = "smart";
        focus-mode = "sloppy";
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = imap0 (i: _: "/${kbdId i}/") keybindings;
      };
      "GWeather4" = { temperature-unit = "centigrade"; };
    };
}
