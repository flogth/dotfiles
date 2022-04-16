{ config, lib, pkgs, ... }:
with lib;
let cfg = config.local.games;
in {
  options.local.games = { enable = mkEnableOption "local.games"; };

  config = mkIf cfg.enable {
    home.packages = (with pkgs; [ minecraft superTuxKart ]);
  };
}
