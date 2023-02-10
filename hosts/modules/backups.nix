{ config, lib, pkgs, ... }:
{
  services = {
    restic.backups = {
      data = {
        repository = "sftp:backup@flogth.net:.";
        paths = [ "/home/flo/data" ];
        passwordFile = "/etc/restic/data.pw";
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
  };
} 
