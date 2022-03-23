{ config, ... }:

{
  imports = [ ./sway.nix ./waybar.nix ];

  xdg = {
    configFile = {
      "swappy/config".source = ../../config/swappy/config;
      "swaylock/config".source = ../../config/swaylock/config;
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
