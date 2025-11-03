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

  networking.wireless.enable = true;
  # Use an external wpa_supplicant-style secrets file if present.
  # Create `wifi-secrets.conf` (gitignored) with your network secrets.
  # networking.wireless.secretsFile = if builtins.pathExists ./wifi-secrets.conf then ./wifi-secrets.conf else null;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    device = "nodev";
    efiSupport = true;
  };

  time.timeZone = "America/New_York";
  
  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
    pkgs.helix
    pkgs.zellij
    pkgs.zoxide

    # dev software
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
  };

  system.stateVersion = "25.05";
}
