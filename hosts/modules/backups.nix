{ config, lib, pkgs, ... }:
let mlib = import ../../lib/rot13.nix { inherit config lib pkgs;};
in {
  services = {
    restic.backups = {
      data = {
        repository =
          mlib.rot13 "f3:rh-prageny-1.yvabqrbowrpgf.pbz/onpxhcf-erfgvp/rhyre";
        paths = [ "/home/flo/data" ];
        passwordFile = "/etc/restic/data.pw";
        environmentFile = "/etc/restic/data.env";
      };
    };
    # snapper = {
    #   snapshotInterval = "daily";
    #   cleanupInterval = "weekly";
    #   configs = {
    #     home = {
    #       subvolume = "/home";
    #       extraConfig = ''
    #         ALLOW_USERS="flo"
    #         TIMELINE_CREATE=yes
    #         TIMELINE_CLEANUP=yes
    #       '';
    #     };
    #   };
    # };
  };
} 
