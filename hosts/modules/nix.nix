{ config, pkgs, ... }: {
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      trusted-substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      auto-optimise-store = true;
      allowed-users = [ "@wheel" ];
    };
  };

  environment = {
    defaultPackages = pkgs.lib.mkForce [ ];
    systemPackages = with pkgs; [ gnupg git clang gcc ];
  };
}
