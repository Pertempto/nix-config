{
  lib,
  pkgs,
  time-tracker,
  opencode,
  ...
}:
{
  environment.systemPackages = map lib.lowPrio [
    # core tools
    pkgs.curl
    pkgs.gitMinimal
    pkgs.jujutsu
    pkgs.zoxide
    pkgs.jq
    pkgs.dig
    pkgs.nmap
    pkgs.just

    # core TUIs
    pkgs.btop
    pkgs.zellij
    pkgs.helix
    pkgs.scooter
    pkgs.sc-im

    # software development tools
    pkgs.gh
    pkgs.glab
    pkgs.flutter
    pkgs.go
    pkgs.nodejs_24
    pkgs.prettier
    pkgs.android-tools
    pkgs.amp-cli
    pkgs.pre-commit

    # language servers
    pkgs.gopls
    pkgs.just-lsp
    pkgs.typescript-language-server
    pkgs.marksman
    pkgs.ltex-ls-plus

    # custom tools
    pkgs.weather
    time-tracker.packages.${pkgs.system}.default
    opencode.packages.${pkgs.system}.default
  ];

  environment.variables.EDITOR = "hx";

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "addison";
      plugins = [
        "git"
        "jj"
      ];
      custom = "$HOME/nix-config/oh-my-zsh";
    };
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellInit = ''
      eval "$(zoxide init zsh)"
      # Disable zsh's newuser startup script that prompts you to create
      # a ~/.z* file if missing
      zsh-newuser-install() { :; }

      AI_DEV_COMPOSE_FILE=~/nix-config/docker/ai-dev/docker-compose.yml

      # buildAiDevImage: force rebuild of the local ai-dev image
      buildAiDevImage() {
        docker compose -f "$AI_DEV_COMPOSE_FILE" build ai-dev
      }

      # aiDev: build local image if missing and run with CWD mounted
      aiDev() {
        mkdir -p "$HOME/.local/share/opencode" "$HOME/.local/state/opencode"
        docker compose -f "$AI_DEV_COMPOSE_FILE" run --rm -v "$PWD":/work ai-dev "$@"
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
    ];
  };
}
