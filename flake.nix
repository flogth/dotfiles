{
  description = "My personal system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "emacs-overlay";
    };

    declarative-cachix = {
      url = "github:jonascarpay/declarative-cachix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, emacs-overlay, declarative-cachix, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = [ emacs-overlay.overlay ];
      };
      lib = nixpkgs.lib;
      cachix =
        declarative-cachix.homeManagerModules.declarative-cachix-experimental;
      mkHomeManagerConfiguration = { host, username ? "flo" }:
        home-manager.lib.homeManagerConfiguration {
          inherit system pkgs username;
          homeDirectory = "/home/${username}";
          configuration = { imports = [ ./home/${host} cachix ]; };
        };
    in {
      homeConfigurations = {
        zuse = mkHomeManagerConfiguration { host = "zuse"; };
        euler = mkHomeManagerConfiguration { host = "euler"; };
      };

      nixosConfigurations = {
        euler = lib.nixosSystem {
          inherit system pkgs;
          modules = [ ./hosts/euler/configuration.nix ];
        };
        zuse = lib.nixosSystem {
          inherit system pkgs;
          modules = [ ./hosts/zuse/configuration.nix ];
        };
      };
    };
}
