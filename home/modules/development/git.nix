{ ... }: {
  programs.git = {
    enable = true;
    userName = "flodobeutlin";
    userEmail = "flodobeutlin@mailbox.org";
    signing.signByDefault = true;
    signing.key = "flodobeutlin@mailbox.org";
    aliases = {
      co = "checkout";
      tree = "log --graph --pretty=short --all";
    };
    includes = [{
      condition = "gitdir:/home/flo/data/uni/**/.git";
      path = "/home/flo/data/uni/uni-git.inc";
    }];
    extraConfig = {
      color.ui = true;
      diff.mnemonicPrefix = true;
      init.defaultBranch = "main";
      log = {
        abbrevCommit = true;
        showSignature = true;
      };
      pull.rebase = true;
    };
  };
  programs.gpg = {
    enable = true;
    settings = {
      keyid-format = "0xlong";
      with-fingerprint = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "gnome3";
    defaultCacheTtl = 1800;
    extraConfig = ''
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
  };
}
