{ config, lib, ... }:
with lib;
let cfg = config.local.git;

in {
  options.local.git = { signingKey = mkOption { type = types.str; }; };
  config = {
    programs.git = {
      enable = true;
      userName = "flogth";
      userEmail = "flogth@mailbox.org";
      signing.signByDefault = true;
      signing.key = cfg.signingKey;
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
        gpg.format = "ssh";
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
      pinentryFlavor = "gnome3";
      defaultCacheTtl = 1800;
      extraConfig = ''
        allow-emacs-pinentry
        allow-loopback-pinentry
      '';
    };
  };
}
