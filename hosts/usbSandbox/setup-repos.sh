#!/usr/bin/env bash

# Create a random unique subdirectory in /tmp
TEMP_DIR=$(mktemp -d -t repos-config-XXXXXX)

# Clone repo configuration from private GitLab repo
git clone git@gitlab.com:aemig_mrs/repos-config.git "$TEMP_DIR"

# Clone all my configured repos
~/nix-config/scripts/clone-repos.sh "$TEMP_DIR/repos.conf"
