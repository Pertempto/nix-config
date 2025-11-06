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
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };

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

  services.openvpn.servers = {
    officeVPN = { config = '' config /home/addison/Documents/sslvpn-addison.emig@mrs-electronics.com-client-config.ovpn ''; };
  };
  
  environment.systemPackages = with pkgs; [
    pkgs.wl-clipboard
    pkgs.vivaldi
    pkgs.slack
    pkgs.teams-for-linux
    pkgs.keepassxc
    pkgs.pika-backup
    pkgs.beekeeper-studio
  ];

  nixpkgs.config.permittedInsecurePackages = [
    # It is marked insecure because it uses Electron v31, but it should be ok
    "beekeeper-studio-5.3.4"
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];
  
  system.stateVersion = "25.05";
}
