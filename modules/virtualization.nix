{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.qemu
    pkgs.gnome-boxes
    pkgs.slirp4netns
    pkgs.packer
    pkgs.virtualbox
  ];

  users.users.addison.extraGroups = [
    "libvirtd"
    # WARNING: Beware that docker group membership is
    #          effectively equivalent to being root!
    "docker"
    "vboxusers"
  ];

  virtualisation = {
    libvirtd.enable = true;
    containers.enable = true;
    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };

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
