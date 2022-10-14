{ modulesPath, pkgs, lib, ... }: {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ../modules/nix.nix ];
  boot.loader.grub.device = "/dev/sda";
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };
  
  fileSystems."/run/mount/backup" = {
    device = "/dev/disk/by-label/backup";
    fsType = "btrfs";
    options = [ "defaults" "discard=async" "compress=zstd" "subvol=@" ];
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
        "flodobeutlin.xyz" = {
          serverAliases = [ "www.flodobeutlin.xyz" ];
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
      passwordAuthentication = false;
      allowSFTP = true;
      kbdInteractiveAuthentication = false;
      extraConfig = ''
        AllowTcpForwarding yes
        X11Forwarding no
        AllowAgentForwarding no
        AllowStreamLocalForwarding no
        AuthenticationMethods publickey
        PermitRootLogin no
      '';
    };
  };

  security = {
    sudo.execWheelOnly = true;
    auditd.enable = true;
    audit.enable = true;
  };

  networking = {
    hostName = "noether";
    enableIPv6 = true;
    useDHCP = true;
    dhcpcd = { persistent = true; };
    interfaces.ens3.ipv6.addresses = [{
      address = "2a01:4f8:1c1e:5e2a::";
      prefixLength = 64;
    }];
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 443 ];
    };
  };

  boot.cleanTmpDir = true;
  zramSwap.enable = true;

  users.users = {
    admin = {
      isNormalUser = true;
      createHome = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAAXV+u3HNdoWtbM3qqoiw12edDZpmy7h2/Q8uWUXZlX euler"
      ];
    };
    git = {
      isNormalUser = true;
      createHome = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAAXV+u3HNdoWtbM3qqoiw12edDZpmy7h2/Q8uWUXZlX euler"
      ];
    };
    backup = {
      isNormalUser = true;
      createHome = false;
      home = "/run/mount/backup";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAAXV+u3HNdoWtbM3qqoiw12edDZpmy7h2/Q8uWUXZlX euler"
      ];

    };
  };
  system.stateVersion = "22.11";
}
