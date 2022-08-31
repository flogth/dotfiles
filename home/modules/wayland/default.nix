{ ... }:

{
  imports = [ ./sway.nix ./waybar.nix ];

  xdg = {
    configFile = {
      "swappy/config".source = ../../config/swappy/config;
      "swaylock/config".source = ../../config/swaylock/config;
      "wofi/base.config".source = ../../config/wofi/base.config;
      "wofi/menu.config".source = ../../config/wofi/menu.config;
      "wofi/base.colors".source = ../../config/wofi/base.colors;
      "wofi/base.css".source = ../../config/wofi/base.css;
      "wofi/menu.css".source = ../../config/wofi/menu.css;
    };
  };

  systemd.user.sessionVariables = {
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };
}
