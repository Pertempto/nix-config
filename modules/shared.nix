{
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
    pkgs.helix
    pkgs.zellij
    pkgs.zoxide
    pkgs.qemu
    pkgs.gnome-boxes
    pkgs.btop

    # dev software
    pkgs.gh
    pkgs.glab
    pkgs.flutter
    pkgs.go
    pkgs.jq
    pkgs.nodejs_24
  ];

  environment.variables.EDITOR = "hx";

  time.timeZone = "America/New_York";

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" ];
    };
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellInit = ''
      eval "$(zoxide init zsh)"
      # Disable zsh's newuser startup script that prompts you to create
      # a ~/.z* file if missing
      zsh-newuser-install() { :; }

      # aiDev: build local image if missing and run with CWD mounted
      aiDev() {
        local image="ai-dev:latest"
        if [ -z "$(docker images -q "$image" 2>/dev/null)" ]; then
          buildAiDevImage
        fi
        docker run --rm -it -v "$PWD":/work -v "$HOME/.config/opencode:/root/.config/opencode" -w /work "$image" "$@"
      }

      # buildAiDevImage: force rebuild of the local ai-dev image
      buildAiDevImage() {
        local image="ai-dev:latest"
        docker build --no-cache -t "$image" -f ~/nix-config/docker/Dockerfile.ai-dev ~/nix-config
      }
    '';
  };

  users.users.addison = {
    isNormalUser = true;
    home = "/home/addison";
    description = "Addison Emig";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "podman"
    ];
  };

  virtualisation = {
    libvirtd.enable = true;
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true; 
    };
  };
}
