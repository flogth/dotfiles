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

  };

  outputs = { nixpkgs, home-manager, emacs-overlay, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = [ emacs-overlay.overlay ];
      };
      lib = nixpkgs.lib;
    in {
      devShells."${system}".default = import ./shell.nix { inherit pkgs; };
      nixosConfigurations = {
        euler = lib.nixosSystem {
          inherit system pkgs;
          modules = [
            ./hosts/euler/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = let
                args = {
                  terminal = {
                    enable = true;
                    fontSize = 10;
                  };
                };
              in {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.flo = import ./home/home.nix { inherit pkgs lib args; };
                verbose = true;
              };
            }
          ];
        };
        zuse = lib.nixosSystem {
          inherit system pkgs;
          modules = [
            ./hosts/zuse/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = let
                args = {
                  terminal = {
                    enable = true;
                    fontSize = 14;
                  };
                  games.enable = true;
                };
              in {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.flo = import ./home/home.nix { inherit pkgs lib args; };
                verbose = true;
              };
            }
          ];
        };
        noether = lib.nixosSystem {
          inherit system;
          pkgs = import nixpkgs { inherit system;};
          modules = [
            ./hosts/noether/configuration.nix
          ];
        };
      };
    };
}
