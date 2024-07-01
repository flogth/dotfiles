{ pkgs, ... }: {
  security = {
    audit.enable = true;
    auditd.enable = true;
    tpm2.enable = true;
    sudo.execWheelOnly = true;
    apparmor = {
      enable = true;
      packages = [ pkgs.apparmor-profiles ];
    };
  };

  programs.firejail.enable = true;

  services = {
    logind = {
      lidSwitch = "suspend-then-hibernate";
      lidSwitchExternalPower = "suspend";
    };

    fprintd = {
      enable = true;
      tod = {
        enable = true;
        driver = pkgs.libfprint-2-tod1-elan;
      };
    };

    fwupd.enable = true;
  };
}
