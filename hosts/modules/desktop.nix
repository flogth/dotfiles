{ config, pkgs, ... }: {

  services = {
    dbus = {
      packages = [pkgs.gcr];
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

  programs.sway = {
    enable = true;
    extraPackages = pkgs.lib.mkForce [];
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = { ovmf.enable = true; };
    };
  };
  
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    gtkUsePortal = true;
  };
}
