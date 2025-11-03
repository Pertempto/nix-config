# Install

The basic steps for installing NixOS from a live USB.

Docs: https://nixos.wiki/wiki/NixOS_Installation_Guide

1. Boot from USB (usually involves triggering the boot menu by using ESC or F12 repeatedly early in the boot process)
1. Run `lsblk` to get the list of disks. Verify the one you want to install to.
1. Set up partitions using `sudo parted /dev/<disk-id>`
   ```sh
   # Example of using fdisk interactively to create a GPT layout with a 500 MiB EFI System Partition on /dev/sdb.
   sudo fdisk /dev/sdb
   # In the fdisk prompt, enter the following commands (each on its own line):
   g               # create a new GPT partition table
   n               # new partition
   1               # partition number 1
   2048            # first sector (aligns to 1MiB by default)
   +500M           # last sector (500 MiB ESP)
   t               # change partition type
   1               # type 1 (EFI System)
   n               # new partition
   2               # partition number 2
   (accept default) # start (press Enter)
   (accept default) # end (press Enter) — use remaining space for root
   w               # write the table and exit
   ```
1. Format partitions
   ```sh
   sudo mkfs.fat -F 32 /dev/sda1
   sudo fatlabel /dev/sda1 NIXBOOT
   sudo mkfs.ext4 /dev/sda2 -L NIXROOT
   ```
1. Mount
   ```sh
   sudo mount /dev/disk/by-label/NIXROOT /mnt
   sudo mkdir -p /mnt/boot
   sudo mount /dev/disk/by-label/NIXBOOT /mnt/boot
   ```
1. Create swap file
   ```sh
   sudo dd if=/dev/zero of=/mnt/.swapfile bs=1024 count=2097152 # 2GB size
   sudo chmod 600 /mnt/.swapfile
   sudo mkswap /mnt/.swapfile
   sudo swapon /mnt/.swapfile
   ```
1. Generate Nix config files
   - `sudo nixos-generate-config --root /mnt --flake`
1. Edit Nix config file with `sudo -e /mnt/etc/nixos/configuration.nix`
   - Set `boot.loader.grub.device = "nodev";`
   - Set `boot.loader.grub.efiSupport = true;`
   - Set `time.timeZone = "America/New_York";`
   - Enable flakes: `nix.settings.experimental-features = [ "nix-command" "flakes" ];`
   - Add a user in `users.users`
     - Set home directory
   - Add `git` and `helix` to `environment.systemPackages`
1. Edit Nix hardware config file with `sudo -e /mnt/etc/nixos/hardware-configuration.nix`
   - Set the file system by disk labels
1. Install
   ```sh
   cd /mnt
   sudo nixos-install
   ```
1. Shutdown
1. Boot up
1. Login as root
1. Set user password: `passwd <username>`
1. Logout from root
1. Login as user
