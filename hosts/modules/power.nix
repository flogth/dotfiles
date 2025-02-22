{ ... }: {
  services.power-profiles-daemon.enable = false;
  systemd.suppressedSystemUnits =
    [ "systemd-backlight@backlight:acpi_video0.service" ];

}
