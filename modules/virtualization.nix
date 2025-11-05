{
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = map lib.lowPrio [
    pkgs.qemu
    pkgs.gnome-boxes
    pkgs.netavark
    pkgs.aardvark-dns
  ];

  users.users.addison.extraGroups = [
    "libvirtd"
    "podman"
  ];

  virtualisation = {
    libvirtd.enable = true;
    containers.enable = true;
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true; 
    };
  };

  networking.firewall.interfaces.podman0.allowedUDPPorts = [ 53 ];
}
