{
  description = "NixOS Configuration for ocm285";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-software-center.url = "github:snowfallorg/nix-software-center";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {

      nixosConfigurations = {
        ocm285 = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs outputs unstable;
          };
          modules = [
            ./hosts/ocm285/configuration.nix
          ];
        };
      };

      homeConfigurations = {
        tim = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs unstable;
          };
          modules = [ ./hosts/ocm285/home.nix ];
        };
      };
    };
}
