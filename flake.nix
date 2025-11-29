{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
  inputs.agenix.url = "github:ryantm/agenix";
  inputs.agenix.inputs.nixpkgs.follows = "nixpkgs";
  inputs.time-tracker.url = "github:mrs-electronics-inc/time-tracker";
  inputs.time-tracker.inputs.nixpkgs.follows = "nixpkgs";
  inputs.opencode.url = "github:sst/opencode/dev";

  outputs =
    {
      nixpkgs,
      disko,
      home-manager,
      agenix,
      time-tracker,
      opencode,
      ...
    }:
    {
      nixosConfigurations.dev-server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          agenix.nixosModules.default
          ./hosts/dev-server/configuration.nix
          ./modules/shared.nix
          ./modules/virtualization.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.users.addison = import ./modules/home.nix;
          }
        ];
        specialArgs = {
          inherit time-tracker opencode;
        };
      };
      nixosConfigurations.usb-sandbox = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/usb-sandbox/configuration.nix
          ./modules/shared.nix
          ./modules/virtualization.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.users.addison = import ./modules/home.nix;
          }
        ];
        specialArgs = {
          inherit time-tracker opencode;
        };
      };
      nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/thinkpad/configuration.nix
          ./modules/shared.nix
          ./modules/virtualization.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.users.addison = import ./modules/home.nix;
          }
        ];
        specialArgs = {
          inherit time-tracker opencode;
        };
      };
    };
}
