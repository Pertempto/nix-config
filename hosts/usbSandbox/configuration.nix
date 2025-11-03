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

  # Load wifi credentials from a gitignored file `wifi-secrets.nix`.
  # The file should export an attrset: { networks = { "SSID" = { psk = "password"; }; }; }
  networking.wireless.networks = if builtins.pathExists ./wifi-secrets.nix then (import ./wifi-secrets.nix).networks else {};

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
      };
    };
  };

  system.stateVersion = "25.05";
}
