{ pkgs, ... }:
{
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
}
