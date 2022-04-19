{ config, lib, pkgs,...}:
{
  fonts.fonts = with pkgs; [
    emacs-all-the-icons-fonts
    fira
    font-awesome
    iosevka
    julia-mono
    noto-fonts
    noto-fonts-emoji
    overpass
  ];
    
}
