{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
  inputs.time-tracker.url = "github:mrs-electronics-inc/time-tracker";
  inputs.time-tracker.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    {
      nixpkgs,
      disko,
      home-manager,
      time-tracker,
      ...
    }:
    {
      nixosConfigurations.devServer = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./hosts/devServer/configuration.nix
          ./modules/shared.nix
          ./modules/virtualization.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.users.addison = import ./modules/home.nix;
          }
        ];
        specialArgs = {
          inherit time-tracker;
        };
      };
      nixosConfigurations.usbSandbox = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/usbSandbox/configuration.nix
          ./modules/shared.nix
          ./modules/virtualization.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.users.addison = import ./modules/home.nix;
          }
        ];
        specialArgs = {
          inherit time-tracker;
        };
      };
    };
}
