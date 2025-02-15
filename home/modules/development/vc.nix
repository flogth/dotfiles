{ config, lib, pkgs, ... }:
let cfg = config.local.git;
in {
  options.local.git = { signingKey = lib.mkOption { type = lib.types.str; }; };
  config = {
    programs.git = {
      enable = true;
      lfs.enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = "flogth";
      userEmail = "flogth@mailbox.org";
      signing = {
        signByDefault = true;
        key = cfg.signingKey;
        format = "ssh";
      };
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
        gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
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
      defaultCacheTtl = 1800;
      extraConfig = ''
        allow-emacs-pinentry
        allow-loopback-pinentry
      '';
    };
    home.packages = [ pkgs.rcs ];
  };
}
