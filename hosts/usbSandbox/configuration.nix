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

  nixpkgs.config.allowUnfree = true;

  # See https://wiki.nixos.org/wiki/NetworkManager
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    device = "nodev";
    efiSupport = true;
  };

  time.timeZone = "America/New_York";

  # Enable the COSMIC login manager
  services.displayManager.cosmic-greeter.enable = true;

  # Enable the COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;
  
  environment.systemPackages = map lib.lowPrio [
    # basic tools
    pkgs.curl
    pkgs.gitMinimal
    pkgs.helix
    pkgs.zellij
    pkgs.zoxide
    pkgs.vivaldi
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

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  environment.variables.EDITOR = "hx";

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

  home-manager.users.addison = {
    home.stateVersion = "25.05";

      programs.zsh = {
      enable = true;
      shellAliases = {
        u = "~/nix-config/hosts/usbSandbox/update.sh";
        t = "echo Test!";
        pastebin = "curl -s --data-binary @- 'https://paste.c-net.org/'";
      };
    };

    programs.git = {
      enable = true;
      settings = {
        user.name = "Addison Emig";
        user.email = "addison.emig@mrs-electronics.com";
        push = { autoSetupRemote = true; };
      };
    };
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
  
  system.stateVersion = "25.05";
}
