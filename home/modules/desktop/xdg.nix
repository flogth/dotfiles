{ config, pkgs, ... }:

{
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "$HOME/data/.desktop";
      documents = "$HOME/data/docs";
      download = "$HOME/downloads";
      music = "$HOME/data/music";
      pictures = "$HOME/data/pictures";
      publicShare = "$HOME/data/.public";
      templates = "$HOME/data/.templates";
      videos = "$HOME/data/videos";
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
        "image/png" = [ "imv.desktop" ];
      };
    };

  };
  systemd.user.sessionVariables = let inherit (config.xdg) userDirs;
                                  in {
                                    # XDG user dirs
                                    XDG_DESKTOP_DIR = userDirs.desktop;
                                    XDG_DOCUMENTS_DIR = userDirs.documents;
                                    XDG_DOWNLOAD_DIR = userDirs.download;
                                    XDG_MUSIC_DIR = userDirs.music;
                                    XDG_PICTURES_DIR = userDirs.pictures;
                                    XDG_PUBLICSHARE_DIR = userDirs.publicShare;
                                    XDG_TEMPLATES_DIR = userDirs.templates;
                                    XDG_VIDEOS_DIR = userDirs.videos;
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
