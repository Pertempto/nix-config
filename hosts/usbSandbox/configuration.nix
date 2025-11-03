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

    # dev software
    pkgs.gh
    pkgs.glab
    pkgs.flutter
    pkgs.go
    pkgs.jq
    pkgs.nodejs_24
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

  system.stateVersion = "25.05";
}
