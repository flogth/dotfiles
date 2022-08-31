{ pkgs, ... }:

{
  imports = [ ./games.nix ./gtk.nix ./xdg.nix ./terminal.nix ./work.nix ];
  home.packages = with pkgs; [
    keepassxc # password manager
    gnome.nautilus # file manager
    inkscape # vector image editor
    pavucontrol # audio configuration
    signal-desktop # messenger
    wpa_supplicant_gui # gui for wifi connections
    simple-scan # scanning frontend
    mpv
    calibre
    gnome.gnome-calendar
  ];

  programs = {
    firefox = {
      enable = true;
      package = pkgs.firefox-wayland;
    };

    texlive = {
      enable = true;
      extraPackages = tpkgs: { inherit (tpkgs) scheme-full; };
    };

    zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
        guioptions = "svh";
        font = "JuliaMono 12";
        statusbar-bg = "#6f18f2";
        default-bg = "#282a36";
        window-title-basename = true;
      };
    };
  };

  services = {
    # fnott = {
    #   enable = true;
    #   settings = {
    #     main = {
    #       notification-margin = 5;
    #       anchor = "bottom-right";
    #       selection-helper = "wofi --dmenu";
    #       title-font = "JuliaMono:size=10:weight=bold";
    #       summary-font = "JuliaMono:size=8";
    #       body-font = "JuliaMono:size=8";
    #     };
    #     low = { default-timeout = 5; };
    #     normal = {
    #       default-timeout = 5;
    #       background = "c678dd";
    #     };
    #     critical = { };
    #   };
    # };
    # playerctld.enable = true;
    udiskie = {
      enable = true;
      automount = false;
      tray = "never";
    };
    syncthing.enable = true;
  };

  # systemd.user.services.fnott.Install.WantedBy = [ "graphical-session.target" ];

  systemd.user.services.polkit = {
    Unit.Description = "Polkit graphical client";
    Unit.PartOf = [ "graphical-session.target" ];
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart =
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "always";
      RestartSec = "3";
    };
  };

  #   systemd.user.services.wob-audio = {
  #     Unit.Description = "Overlay for volume changes";
  #     Unit.PartOf = [ "graphical-session.target" ];
  #     Unit.After = [ "graphical-session.target" ];
  #     Unit.ConditionEnvironment = "WAYLAND_DISPLAY";
  #     Install.WantedBy = [ "graphical-session.target" ];
  #     Service = {
  #       ExecStart =
  #         "${pkgs.wob}/bin/wob --background-color '#12151daa' --bar-color '#c678ddff' -b 2 -o 0";
  #       StandardInput = "socket";
  #     };
  #   };

  #   systemd.user.sockets.wob-audio = {
  #     Socket.ListenFIFO = "%t/wob-audio.sock";
  #     Socket.SocketMode = "0600";
  #     Install.WantedBy = [ "sockets.target" ];
  #   };

  #   systemd.user.services.wob-brightness = {
  #     Unit.Description = "Overlay for brightness changes";
  #     Unit.PartOf = [ "graphical-session.target" ];
  #     Unit.After = [ "graphical-session.target" ];
  #     Unit.ConditionEnvironment = "WAYLAND_DISPLAY";
  #     Install.WantedBy = [ "graphical-session.target" ];
  #     Service = {
  #       ExecStart =
  #         "${pkgs.wob}/bin/wob --background-color '#12151daa' --bar-color '#98c379ff' -b 2 -o 0 -m 255";
  #       StandardInput = "socket";
  #     };
  #   };

  #   systemd.user.sockets.wob-brightness = {
  #     Socket.ListenFIFO = "%t/wob-brightness.sock";
  #     Socket.SocketMode = "0600";
  #     Install.WantedBy = [ "sockets.target" ];
  #   };
  }
