{config,pkgs,...}:
{
  home.packages = with pkgs; [
    remmina
    openvpn
  ];
  programs.chromium = {
    enable = true;
  }; 
}
