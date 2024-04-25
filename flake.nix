{
  description = "My personal system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; };
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
      lib = nixpkgs.lib;
    in
    {
      devShells."${system}".default = import ./shell.nix { inherit pkgs; };
      nixosConfigurations = {
        euler = lib.nixosSystem {
          inherit system pkgs;
          modules = [
            ./hosts/euler/configuration.nix
            home-manager.nixosModules.home-manager
            nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd
            {
              home-manager =
                let
                  args = {
                    git = {
                      signingKey =
                        "key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAAXV+u3HNdoWtbM3qqoiw12edDZpmy7h2/Q8uWUXZlX";
                    };
                  };
                in
                {
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
              home-manager =
                let
                  args = {
                    git = {
                      signingKey =
                        "key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkmMVJ5DRZOLPf68aeRBF95ijtTRvV10/a2SW9n+gX+";
                    };
                  };
                in
                {
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
          pkgs = import nixpkgs { inherit system; };
          modules = [ ./hosts/noether/configuration.nix ];
        };
      };
    };
}
