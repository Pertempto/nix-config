#!/usr/bin/env bash
# This script is a simple way to pull the newest flake and rebuild.
# It requires github.com/pertempto/nix-config to be cloned in ~/nix-config
# TODO: use $(hostname) instead of static thinkpad value so this script
# can be moved to scripts/ directory

cd ~/nix-config
sudo nixos-rebuild switch --flake .#thinkpad
cd -
