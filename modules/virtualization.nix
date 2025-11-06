{
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = map lib.lowPrio [
    pkgs.podman-compose
    pkgs.qemu
    pkgs.gnome-boxes
    pkgs.slirp4netns
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

  # Only use docker.io registry by default
  environment.etc."containers/registries.conf".text = lib.mkForce ''
    [registries.search]
    registries = ['docker.io']

    [registries.insecure]
    registries = []

    [registries.block]
    registries = []
  '';
}
