{
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = map lib.lowPrio [
    pkgs.qemu
    pkgs.gnome-boxes
    pkgs.slirp4netns
  ];

  users.users.addison.extraGroups = [
    "libvirtd"
  ];

  virtualisation = {
    libvirtd.enable = true;
    containers.enable = true;
  };
}
