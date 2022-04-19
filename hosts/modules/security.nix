{ config, lib, pkgs, ... }: {
  security = {
    audit.enable = true;
    auditd.enable = true;
    tpm2.enable = true;
    sudo.execWheelOnly = true;
  };

  programs.firejail.enable = true;

  services = {
    logind = {
      lidSwitch = "suspend-then-hibernate";
      lidSwitchExternalPower = "suspend";
    };

    getty = {
      loginOptions = "-p -- flo";
      extraArgs = [ "--skip-login" ];
    };
    fwupd.enable = true;
  };
}
