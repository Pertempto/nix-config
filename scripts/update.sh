#!/usr/bin/env bash
# This script is a simple way to pull the newest flake and rebuild.
# It requires github.com/pertempto/nix-config to be cloned in ~/nix-config

cd ~/nix-config
sudo nixos-rebuild switch --flake .#$(hostname)
cd -
