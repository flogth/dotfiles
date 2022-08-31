{ pkgs, ... }: {
  fonts.fonts = with pkgs; [
    emacs-all-the-icons-fonts
    fira
    font-awesome
    julia-mono
    noto-fonts
    noto-fonts-emoji
    overpass
  ];

}
