{ config, lib, pkgs, ... }: {

  time.timeZone = "Europe/Berlin";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };
}
