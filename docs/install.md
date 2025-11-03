# Install

The basic steps for installing NixOS from a live USB.

Docs: https://nixos.wiki/wiki/NixOS_Installation_Guide

1. Boot from USB (usually involves triggering the boot menu by using ESC or F12 repeatedly early in the boot process)
1. Run `lsblk` to get the list of disks. Verify the one you want to install to.
1. Set up partitions using `sudo parted /dev/<disk-id>`
   ```sh
   mklabel msdos
   mkpart primary ext4 1MiB 1GiB
   mkpart primary btrfs 1GiB -4GiB
   mkpart primary linux-swap -4GiB 100%
   set 1 boot on
   print
   quit
   ```
1. Format partitions
   - `sudo mkfs.ext4 /dev/vda1`
   - `sudo mkfs.btrfs /dev/vda2`
   - `sudo mkswap /dev/vda3`
1. Mount
   - `sudo mount /dev/vda2 /mnt`
   - `sudo mkdir /mnt/boot`
   - `sudo mount /dev/vda1 /mnt/boot`
   - `sudo swapon /dev/vda3`
1. Generate Nix config files
   - `sudo nixos-generate-config --root /mnt --flake`
