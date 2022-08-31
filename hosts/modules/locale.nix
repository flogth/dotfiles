{ ... }: {

  time.timeZone = "Europe/Berlin";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
    };
  };

  console = {
    keyMap = "us";
  };
}
