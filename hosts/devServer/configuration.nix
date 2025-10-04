{
  modulesPath,
  lib,
  pkgs,
  ...
} @ args:
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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.defaultGateway = "192.168.31.1";
  networking.nameservers = ["192.168.31.2"];
  networking.interfaces.ens18.ipv4.addresses = [
    {
      address = "192.168.31.23";
      prefixLength = 24;
    }
  ];

  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys =
  [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSuWXV6LTpMKtNOpluR3umIJlh+94p0yJTXNNDqQeUV"
  ] ++ (args.extraPublicKeys or []); # this is used for unit-testing this module and can be removed if not needed

  system.stateVersion = "24.05";
}
