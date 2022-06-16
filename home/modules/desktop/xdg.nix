{ config, pkgs, ... }:
let home = config.home.homeDirectory;
in {
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${home}/data/.desktop";
      documents = "${home}/data/docs";
      download = "${home}/downloads";
      music = "${home}/data/music";
      pictures = "${home}/data/pictures";
      publicShare = "${home}/data/.public";
      templates = "${home}/data/.templates";
      videos = "${home}/data/videos";
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "application/x-extension-html"= "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
        "image/png" = [ "imv.desktop" ];
      };
    };

  };

  home.sessionVariables = let
    configDir = d: "${config.xdg.configHome}/${d}";
    cacheDir = d: "${config.xdg.cacheHome}/${d}";
    dataDir = d: "${config.xdg.dataHome}/${d}";
  in {
    # keep home clean
    CABAL_CONFIG = configDir "cabal/config";
    CABAL_DIR = cacheDir "cabal";
    CARGO_HOME = dataDir "cargo";
    GO_PATH = dataDir "go";
    GRADLE_USER_HOME = dataDir "gradle";
    JUPYTER_CONFIG_DIR = configDir "jupyter";
    DVDCSS_CACHE = dataDir "dvdcss";
    OPAMROOT = dataDir "opam";
  };
  home.packages = [ pkgs.xdg_utils ];
}
