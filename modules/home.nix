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
      pastebin = "curl -s --data-binary @- 'https://paste.c-net.org/'";
      t = "time-tracker";
      tb = "cd $HOME/.config/time-tracker && ./backup.sh && cd -";
      u = "~/nix-config/scripts/update.sh";
      startVpn = "sudo systemctl start openvpn-mrsVPN.service";
      stopVpn = "sudo systemctl stop openvpn-mrsVPN.service";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Addison Emig";
      user.email = "addison.emig@mrs-electronics.com";
      push = { autoSetupRemote = true; };
      pull = { rebase = true; };
    };
  };
}
