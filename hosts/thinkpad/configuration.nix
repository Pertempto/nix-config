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
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    device = "nodev";
    efiSupport = true;
  };

  # Enable OpenVPN with manual control (no auto-start)
  services.openvpn.servers = {
    mrsVPN = {
      config = '' config /home/addison/Documents/sslvpn-addison.emig@mrs-electronics.com-client-config.ovpn '';
      autoStart = false;
      updateResolvConf = true;
    };
  };

  # Enable the COSMIC login manager
  services.displayManager.cosmic-greeter.enable = true;

  # Enable the COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;
  
  environment.systemPackages = with pkgs; [
    pkgs.wl-clipboard
    pkgs.vivaldi
    pkgs.slack
    pkgs.teams-for-linux
    pkgs.evolution
    pkgs.evolution-ews
    pkgs.keepassxc
    pkgs.pika-backup
    pkgs.beekeeper-studio
    pkgs.harlequin
    pkgs.android-studio
    pkgs.git-repo
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
