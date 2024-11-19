{
  description = "NixOS Configuration for ocm285";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... } @ inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;
        };
      };
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {

      nixosConfigurations = {
        ocm285 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system inputs outputs unstable;
          };
          modules = [
            ./configuration.nix
          ];
        };
      };
    };
}
