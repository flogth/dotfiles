{ config, lib, pkgs, ... }:
with lib;
with builtins;
let cfg = config.local.network;
in {
  options.local.network = {
    enable = mkEnableOption "local.network";
    hostName = mkOption { type = types.str; };
    interfaces = mkOption { type = types.listOf (types.str); };
  };

  config = mkIf cfg.enable {
    networking = {
      hostName = cfg.hostName;
      useDHCP = false;
      dhcpcd.enable = false;
      networkmanager = {
        enable = true;
        dns = "systemd-resolved";
        dhcp = "internal";
      };
      firewall = {
        enable = true;
        allowedTCPPorts = [ 631 ];
        allowedUDPPorts = [ 631 5353 ]; # allow mdns
      };
    };

    services = {
      resolved = {
        enable = true;
        dnssec = "allow-downgrade";
        llmnr = "true";
      };
      openvpn.servers = {
        work = {
          config = "config /etc/openvpn/client/work.ovpn";
          autoStart = false;
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
    };

    programs = {
      gnupg = {
        agent = {
          enable = true;
          pinentryFlavor = "gnome3";
        };
      };
      ssh = {
        startAgent = true;
        agentTimeout = "5m";
      };
    };
  };
}
