{ config, pkgs, ... }:
{
  home.stateVersion = "25.05";

  # Add dot-files to config directory
  home.file."${config.xdg.configHome}" = {
    source = ../dot-files;
    recursive = true;
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      u = "~/nix-config/hosts/usbSandbox/update.sh";
      t = "time-tracker";
      tb = "cd $HOME/.config/time-tracker && ./backup.sh && cd -";
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
