{ pkgs, ... }: {

  environment.gnome.excludePackages = with pkgs; [
    gnome-photos
    gnome-tour
    gnome-music
    gnome-terminal
    gedit
    epiphany
    gnome-characters
    totem
    gnome-text-editor
  ];

  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      excludePackages = [ pkgs.xterm ];
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
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = { ovmf.enable = true; };
    };
    docker = {
      enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    docker-compose
    gnome-tweaks
  ];

  xdg.portal = {
    enable = true;
  };
}
