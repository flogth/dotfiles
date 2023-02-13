{ modulesPath, pkgs, lib, ... }:
let fetchKeys = import ../../lib/fetchKeys.nix { inherit lib; };
in {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ../modules/nix.nix ];

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  boot = {
    loader.grub.device = "/dev/sda";
    loader.timeout = 1;
    initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
    initrd.kernelModules = [ "nvme" ];
    cleanTmpDir = true;

  };

  zramSwap.enable = true;

  security = {
    sudo.execWheelOnly = true;
    auditd.enable = true;
    audit.enable = true;
    apparmor = {
      enable = true;
      packages = [ pkgs.apparmor-profiles ];
    };
  };

  networking = {
    hostName = "noether";
    enableIPv6 = true;
    useNetworkd = true;
    useDHCP = false;
    dhcpcd.enable = false;
    interfaces.ens3 = {
      useDHCP = true;
      ipv6.addresses = [
        {
          address = "2a01:4f8:c2c:b87d::1";
          prefixLength = 64;
        }
      ];
    };
    defaultGateway6 = {
      interface = "ens3";
      address = "fe80::1";
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 443 ];
    };
  };

  time.timeZone = "Europe/Berlin";

  users.users = let keys = fetchKeys.fetchKeys "flogth" "sha256:1kfgh99r2xd818npzqcyziv3dhvzfpzkmxr33bd153rhfdawk027";
  in {
    admin = {
      isNormalUser = true;
      createHome = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = keys;
    };

    git = {
      isNormalUser = true;
      createHome = true;
      openssh.authorizedKeys.keys = keys;
    };

    backup = {
      isNormalUser = true;
      createHome = false;
      home = "/run/mount/backup";
      openssh.authorizedKeys.keys = keys;
    };
  };

  programs = {
    git.enable = true;
    neovim.enable = true;
  };

  environment.systemPackages = with pkgs; [ rsync ];

  services = {
    caddy = {
      enable = true;
      email = "flodobeutlin@mailbox.org";
      virtualHosts = {
        "flogth.net" = {
          serverAliases = [ "www.flogth.net" ];
          extraConfig = ''
            encode gzip zstd
            root * /var/www/html
            try_files {path}.html {path}
            file_server
            header / {
              X-Robots-Tag "noindex"
              X-Content-Type-Options "nosniff"
              X-Frame-Options "Deny"
              Content-Security-Policy "
                default-src 'self';
              "
            }
          '';
        };
      };
    };
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
      allowSFTP = true;
      extraConfig = ''
        AllowTcpForwarding yes
        X11Forwarding no
        AllowAgentForwarding no
        AllowStreamLocalForwarding no
        AuthenticationMethods publickey
        PermitRootLogin no
      '';
    };
    fail2ban.enable = true;
  };

  system.stateVersion = "22.11";
}
