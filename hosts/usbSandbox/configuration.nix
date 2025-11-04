{
  modulesPath,
  lib,
  pkgs,
  ...
}@args:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # See https://wiki.nixos.org/wiki/NetworkManager
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    device = "nodev";
    efiSupport = true;
  };

  # Enable the COSMIC login manager
  services.displayManager.cosmic-greeter.enable = true;

  # Enable the COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;
  
  environment.systemPackages = with pkgs; [
    pkgs.vivaldi
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];
  
  system.stateVersion = "25.05";
}
