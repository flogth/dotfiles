{ pkgs, ... }: {
  home.packages = with pkgs; [ remmina openvpn ];
  programs.chromium = {
    enable = true;
    commandLineArgs = [ "--ozone-platform-hint=auto" ];
  };
}
