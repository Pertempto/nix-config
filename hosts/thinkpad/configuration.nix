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

  time.timeZone = "America/Mexico_City";
  # time.timeZone = "America/New_York";

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
    wl-clipboard
    vivaldi
    chromium
    slack
    teams-for-linux
    keepassxc
    pika-backup
    beekeeper-studio
    harlequin
    # AWS tools
    awscli2
    awsebcli
    # Qt tools
    qt5.qtbase
    qt5.qtbase.dev
    qtcreator
    gnumake
    gcc
    binutils
    # Android tools
    android-studio
    git-repo
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
