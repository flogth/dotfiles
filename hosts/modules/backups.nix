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
          SUBVOLUME        = "/home";
          ALLOW_USERS      = ["flo"];
          TIMELINE_CREATE  = true;
          TIMELINE_CLEANUP = true;
        };
      };
    };
  };
} 
