{ config, pkgs, lib, home-manager, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      trusted-substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      auto-optimise-store = true;
      allowed-users = [ "@wheel" ];
    };
  };

  networking = {
    hostName = "zuse";
    useDHCP = false;
    interfaces.enp5s0.useDHCP = true;
    interfaces.wlp4s0.useDHCP = true;
    networkmanager.enable = false;
    useNetworkd = true;
    nameservers = [ "9.9.9.9" "2620:fe::fe" ];
    wireless = {
      enable = true;
      userControlled.enable = true;
      environmentFile = "/etc/secrets/wireless.env";
      networks = { weeelan.psk = "@PSK_WEEELAN@"; };
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ 631 ];
      allowedUDPPorts = [ 631 5353 ]; # allow mdns
    };
  };
  systemd.network = {
    enable = true;
    networks = {
      usb = {
        matchConfig = { Name = "enp4s0*"; };
        dhcpV4Config = { RouteMetric = 30; };
      };
    };

  };

  security = {
    audit.enable = true;
    auditd.enable = true;
    tpm2.enable = true;
    sudo.execWheelOnly = true;
  };

  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  services = {
    logind = {
      lidSwitch = "suspend-then-hibernate";
      lidSwitchExternalPower = "suspend";
    };

    getty = {
      loginOptions = "-p -- flo";
      extraArgs = [ "--skip-login" ];
    };

    dbus = {
      packages = [ pkgs.gcr ];
      apparmor = "enabled";
    };

    fwupd.enable = true;

    gnome = {
      gnome-keyring.enable = true;
      core-os-services.enable = true;
    };

    openvpn.servers = {
      work = {
        config = "config /etc/openvpn/client/work.ovpn";
        autoStart = false;
      };
    };

    power-profiles-daemon.enable = false;

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

    resolved = {
      enable = true;
      dnssec = "allow-downgrade";
      llmnr = "true";
    };

    restic.backups = {
      data = {
        repository = "s3:eu-central-1.linodeobjects.com/backups-restic/euler";
        paths = [ "/home/flo/data" ];
        passwordFile = "/etc/restic/data.pw";
        environmentFile = "/etc/restic/data.env";
      };
      data-local = {
        repository = "sftp:backup@zuse:/backup/euler";
        paths = [ "/home/flo/data" ];
        passwordFile = "/etc/restic/data-local.pw";
      };
    };
    snapper = {
      snapshotInterval = "daily";
      cleanupInterval = "weekly";
      configs = {
        home = {
          subvolume = "/home";
          extraConfig = ''
            ALLOW_USERS="flo"
            TIMELINE_CREATE=yes
            TIMELINE_CLEANUP=yes
          '';
        };
      };
    };

    openssh = {
      enable = true;
      passwordAuthentication = false;
      allowSFTP = false;
      kbdInteractiveAuthentication = false;
      permitRootLogin = "no";
      startWhenNeeded = true;
      extraConfig = ''
        AllowTcpForwarding yes
        AllowAgentForwarding no
        AllowStreamLocalForwarding no
      '';
    };

    avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
    tlp = {
      enable = true;
      settings = { USB_AUTOSUSPEND = 0; };
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    gtkUsePortal = true;
  };

  systemd.suppressedSystemUnits =
    [ "systemd-backlight@backlight:acpi_video0.service" ];

  # scanning
  hardware.sane.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  users.users.flo = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

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

  environment = {
    defaultPackages = pkgs.lib.mkForce [ ];
    systemPackages = with pkgs; [ gnupg git clang gcc ];
  };

  programs = {
    firejail = { enable = true; };

    gnupg = {
      agent = {
        enable = true;
        pinentryFlavor = "gnome3";
      };
    };

    neovim = {
      enable = true;
      defaultEditor = true;
    };
    ssh = {
      startAgent = true;
      agentTimeout = "5m";
      extraConfig = ''
        Match user backup host "zuse"
              IdentityFile /etc/restic/id_backup
      '';
    };
    steam.enable = true;
    sway = {
      enable = true;
      extraPackages = pkgs.lib.mkForce [ ];
    };
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = { ovmf.enable = true; };
    };
  };

  system.stateVersion = "21.05";
}
