{ config, pkgs, ... }: {
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      trusted-substituters = [ "https://nix-community.cachix.org" ];
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      auto-optimise-store = true;
      allowed-users = [ "@wheel" ];
      trusted-users = [ "@wheel" ];
    };
  };

  nixpkgs.config.allowUnfree = true;
  environment = {
    defaultPackages = pkgs.lib.mkForce [ ];
    systemPackages = with pkgs; [ gnupg git clang gcc ];
  };
  documentation = {
    dev.enable = true;
    doc.enable = false;
    man = {
      enable = true;
      generateCaches = true;
    };
  };
}
