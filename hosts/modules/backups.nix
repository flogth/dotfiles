{ config, lib, pkgs, ... }:
{
  services = {
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
