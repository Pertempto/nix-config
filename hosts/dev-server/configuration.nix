{
  modulesPath,
  lib,
  pkgs,
  ...
}@args:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking.hostName = "dev-server";

  time.timeZone = "America/New_York";

  networking.defaultGateway = "192.168.31.1";
  networking.nameservers = [ "192.168.31.2" ];
  networking.interfaces.ens18.ipv4.addresses = [
    {
      address = "192.168.31.23";
      prefixLength = 24;
    }
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
    };
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  # Ensure ~/.ssh directory exists with correct ownership before agenix and home-manager run.
  # Without this, agenix creates ~/.ssh as root:root when symlinking the client key,
  # which prevents home-manager from writing the SSH config file.
  systemd.tmpfiles.rules = [
    "d /home/addison/.ssh 0700 addison users -"
  ];

  # Configure agenix secrets
  age.secrets.addison-password.file = ./secrets/addison-password.age;
  age.secrets.dev-server-client-key = {
    file = ./secrets/client-key.age;
    owner = "addison";
    path = "/home/addison/.ssh/id_ed25519";
    mode = "0600";
  };

  users.users.addison = {
    hashedPasswordFile = "/run/agenix/addison-password";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK4iXZohV7G+gtWdGf69DJTV8YsZac0rdCc4CVTIbW8U addison@emig-home-laptop"
    ];
  };

  system.stateVersion = "24.05";
}
