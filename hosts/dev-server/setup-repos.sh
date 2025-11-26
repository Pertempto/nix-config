#!/usr/bin/env bash

# Create a random unique subdirectory in /tmp
TEMP_DIR=$(mktemp -d -t repos-config-XXXXXX)

# Clone repo configuration from private git repo
git clone git@git.kwila.cloud/addison/repos-config.git "$TEMP_DIR"

# Clone all my configured repos
~/nix-config/scripts/clone-repos.sh "$TEMP_DIR/repos.conf"
