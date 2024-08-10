{ pkgs, ... }:
{
  home.packages = with pkgs;
    [
      # basics
      stdenv
      gdb
      gnumake

      # apl
      gnuapl

      # c
      clang-tools
      cmake

      # common lisp
      sbcl

      # haskell
      cabal-install
      ghc
      haskell-language-server
      ormolu

      # js
      nodejs

      # prolog
      swiProlog

      # proof assistants
      coq
      (agda.withPackages [ agdaPackages.standard-library agdaPackages.cubical ])
      lean4

      # python
      python3

      # nix
      nixfmt-classic
      nil

      # rust
      rustc
      cargo

      # shell
      shellcheck

    ];

  home.file = {
    ".ghc/ghci.conf".source = ../../config/ghc/ghci.conf;
    ".guile".source = ../../config/guile/.guile;
    ".agda/defaults".text = ''
      ${pkgs.agdaPackages.standard-library.name}
      ${pkgs.agdaPackages.cubical.name}
    '';
  };

}
