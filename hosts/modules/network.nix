{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.local.network;
  mergeMap = f: xs: foldr (a: b: a // b) { } (map f xs);
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
      interfaces = mergeMap (i: { ${i}.useDHCP = true; }) cfg.interfaces;

      networkmanager.enable = false;
      useNetworkd = false;

      wireless = {
        enable = true;
        userControlled.enable = true;
        environmentFile = "/etc/secrets/wireless.env";
        networks = {
          weeelan.psk = "@PSK_WEEELAN@";
          WLAN_guthmann.psk = "@PSK_WLAN_guthmann@";
          eduroam = {
            auth = ''
              proto=RSN
              key_mgmt=WPA-EAP
              eap=PEAP
              identity="@ID_EDUROAM@"
              password=hash:@PW_HASH_EDUROAM@
              domain_suffix_match="eradius.rrze.uni-erlangen.de"
              anonymous_identity="anonymous@fau.de"
              phase1="peaplabel=0"
              phase2="auth=MSCHAPV2"
              ca_cert="/etc/ssl/certs/eduroam.crt"
            '';
          };
        };
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

    systemd.services.systemd-networkd-wait-online.serviceConfig.ExecStart = [
      ""
      "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any"
    ];
    
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
        extraConfig = ''
          Match user backup host "zuse"
                IdentityFile /etc/restic/id_backup
        '';
      };
    };
  };
}
