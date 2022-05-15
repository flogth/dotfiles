{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    # basics
    stdenv
    gdb
    gnumake
    ninja
    meson

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

    # html
    html-tidy
    # js
    nodejs

    # prolog
    scryer-prolog

    # proof assistants
    coq
    agda

    # python
    python3

    # nix
    nixfmt

    # rust
    rustc
    cargo
    rust-analyzer
    rustfmt

    # shell
    shellcheck

    # scheme
    guile
  ];

  home.file = { ".ghc/ghci.conf".source = ../../config/ghc/ghci.conf; };

}
