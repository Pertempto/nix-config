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
}