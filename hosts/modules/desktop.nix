{ pkgs, ... }: {

  environment.gnome.excludePackages = with pkgs; [
    gnome-photos
    gnome-tour
    gnome.gnome-music
    gnome.gnome-terminal
    gnome.gedit
    gnome.epiphany
    gnome.evince
    gnome.gnome-characters
    gnome.totem
  ];

  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    dbus = {
      packages = [ pkgs.gcr ];
      apparmor = "enabled";
    };
    gnome = {
      gnome-keyring.enable = true;
      core-os-services.enable = true;
    };

    printing = {
      enable = true;
      browsing = true;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  # scanning
  hardware.sane.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = { ovmf.enable = true; };
    };
    docker = {
      enable = true;
      enableNvidia = true;
    };
  };
  environment.systemPackages = with pkgs; [ docker-compose ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
}
