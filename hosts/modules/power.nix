{ ... }: {
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = { USB_AUTOSUSPEND = 0; };
  };
  systemd.suppressedSystemUnits =
    [ "systemd-backlight@backlight:acpi_video0.service" ];

}
