{ config, lib, ... }:
with lib;
with builtins;
let cfg = config.local.network;
in {
  options.local.network = {
    enable = mkEnableOption "local.network";
    hostName = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable {
    networking = {
      hostName = cfg.hostName;
      useDHCP = false;
      dhcpcd.enable = false;
      networkmanager = {
        enable = true;
        dns = "systemd-resolved";
      };
      firewall = {
        enable = true;
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
        allowSFTP = false;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
        };
        startWhenNeeded = true;
        extraConfig = ''
          AllowTcpForwarding yes
          AllowAgentForwarding no
          AllowStreamLocalForwarding no
        '';
      };
    };

    programs = {
      gnupg.agent.enable = true;
      ssh = {
        startAgent = true;
        agentTimeout = "5m";
        extraConfig = let
          hosts = [
            {
              name = "uni";
              hostName = "cipterm0.cip.cs.fau.de";
              user = "oc45ujef";
            }
            {
              name = "blog";
              hostName = "flogth.net";
              user = "admin";
            }
            {
              name = "pi";
              hostName = "raspberrypi.local";
              user = "flo";
              port = 2223;
            }
          ];
        in ''
          Host *
            ServerAliveInterval 300
            ServerAliveCountMax 240
          # Host aliases
          ${flip concatMapStrings hosts (h: ''
            Host ${h.name}
                 HostName ${h.hostName}
                 User ${h.user}
                 Port ${toString (h.port or 22)}
          '')}
        '';
      };
    };
  };
}
