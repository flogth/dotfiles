{ config, lib, pkgs, ... }: {
  services = {
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
  };
}
