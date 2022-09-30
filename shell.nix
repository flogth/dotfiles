{ pkgs ? import <nixpkgs> { } }:

with pkgs;
let
  nixBin = writeShellScriptBin "nix" ''
    ${nixVersion.stable}/bin/nix --option experimental-features "nix-command flakes" "$@"
  '';
in mkShell { buildInputs = [ git ]; }
