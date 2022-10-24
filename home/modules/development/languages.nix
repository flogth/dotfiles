{ pkgs, ... }: {
  home.packages = with pkgs;
    [
      # basics
      stdenv
      gdb
      gnumake
      ninja
      meson

      # apl
      gnuapl
      cbqn

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
      swiProlog

      # proof assistants
      coq
      (agda.withPackages [ agdaPackages.standard-library agdaPackages.cubical ])

      # python
      python3

      # nix
      nixfmt
      rnix-lsp

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

    ] ++ (with pkgs.ocamlPackages; [ pkgs.dune_2 ocaml utop ocaml-lsp ]);

  home.file = {
    ".ghc/ghci.conf".source = ../../config/ghc/ghci.conf;
    ".guile".source = ../../config/guile/.guile;
    ".agda/defaults".text = ''
      ${pkgs.agdaPackages.standard-library.name}
    '';
  };

}
