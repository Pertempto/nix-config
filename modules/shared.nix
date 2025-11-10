{
  lib,
  pkgs,
  time-tracker,
  ...
}:
{
  environment.systemPackages = map lib.lowPrio [
    # core tools
    pkgs.curl
    pkgs.gitMinimal
    pkgs.helix
    pkgs.zellij
    pkgs.zoxide
    pkgs.jq
    pkgs.btop
    pkgs.dig

    # software development tools
    pkgs.gh
    pkgs.glab
    pkgs.flutter
    pkgs.go
    pkgs.nodejs_24
    pkgs.prettier
    pkgs.typescript-language-server

    # custom tools
    time-tracker.packages.${pkgs.system}.default
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

        AI_DEV_COMPOSE_FILE=~/nix-config/docker/ai-dev/docker-compose.yml

        # buildAiDevImage: force rebuild of the local ai-dev image
        buildAiDevImage() {
          docker compose -f "$AI_DEV_COMPOSE_FILE" build --no-cache ai-dev
        }

        # aiDev: build local image if missing and run with CWD mounted
        aiDev() {
          mkdir -p "$HOME/.local/share/opencode" "$HOME/.local/state/opencode"
          docker compose -f "$AI_DEV_COMPOSE_FILE" run --rm --build -v "$PWD":/work ai-dev "$@"
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
