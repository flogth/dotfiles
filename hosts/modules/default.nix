{ config, lib, pkgs,...}: {
  imports = [
    ./backups.nix
    ./desktop.nix
    ./fonts.nix
    ./locale.nix
    ./network.nix
    ./nix.nix
    ./power.nix
    ./programs.nix
    ./security.nix
  ];
}
