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
    # WARNING: Beware that docker group membership is
    #          effectively equivalent to being root!
    "docker"
  ];

  virtualisation = {
    libvirtd.enable = true;
    containers.enable = true;

    docker = {
      enable = true;
      # Set up resource limits
      daemon.settings = {
        experimental = true;
        default-address-pools = [
          {
            base = "172.30.0.0/16";
            size = 24;
          }
        ];
      };
    };
  };
}
