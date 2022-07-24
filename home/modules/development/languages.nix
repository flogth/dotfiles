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
    (agda.withPackages [ agdaPackages.standard-library agdaPackages.cubical ])

    # python
    python3

    # nix
    nixfmt

    # rust
    rustc
    cargo
    cargo-generate
    rust-analyzer
    rustfmt

    # shell
    shellcheck

    # scheme
    guile
    racket

    # wasm
    wasm-pack
  ];

  home.file = {
    ".ghc/ghci.conf".source = ../../config/ghc/ghci.conf;
    ".guile".source = ../../config/guile/.guile;
    ".agda/defaults".text = ''
    ${pkgs.agdaPackages.standard-library.name}
    '';
  };

}
