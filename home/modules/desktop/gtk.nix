{ config, pkgs, ... }:

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
  };
}
