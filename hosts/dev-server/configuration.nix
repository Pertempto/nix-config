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

  # Configure agenix secrets
  age.secrets.addison-password.file = ../../secrets/addison-password.age;

  users.users.addison = {
    hashedPasswordFile = "/run/agenix/addison-password";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSuWXV6LTpMKtNOpluR3umIJlh+94p0yJTXNNDqQeUV"
    ];
  };

  system.stateVersion = "24.05";
}
