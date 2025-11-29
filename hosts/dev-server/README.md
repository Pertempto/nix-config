# Dev Server

The goal of this machine is to have a stable and consistent place for dev work. If I have a client that can SSH into the dev server (over TailScale if I'm remote), then I should be able to make progress with dev work.

## Installation

Followed the basic instructions from the "Creating the NixOS VM" section of [this article](https://bloodstiller.com/homelab/20250220118-nixos-homelab/#creating-the-nixos-vm). Ignore the "Creating an additional drive to host our docker data" section.

- Minimal ISO
- ProxMox VM
  - Set the name to `dev-server`
  - System config:
    - Machine: q35
    - BIOS: OVMF (UEFI)
    - EFI Storage: local-lvm
  - Set storage to 64 GiB (on `local-lvm` for best performance)
  - 1 socket, 4 cores
  - Set memory to 6144 MiB

### Post-install Configuration

- Enable Start at boot
- Update boot order to use the ISO first

## First Boot

- First boot will fail - have to disable secure boot in the BIOS
- Use `sudo passwd` to set root password (for installer only)
- Use `ip a` to get IP address

## NixOS-Anywhere Installation

I have found it is best to reference the flake using `.` rather than the GitHub URL, to make sure we are using the latest version rather than some cached version.

Example install:

```bash
nix run github:nix-community/nixos-anywhere -- --flake .#dev-server --target-host root@192.168.31.246
```

Remove the installer DVD in the ProxMox hardware options before rebooting, otherwise it will keep booting to the installer

## SSH Keys

I manually created the `kwila` and `kwila.pub` SSH key files from values in BitWarden. We need these to push/pull git repos.

```bash
➜  ~ ls -lah ~/.ssh
total 32K
drwxr-xr-x  2 addison users 4.0K Nov 26 17:04 .
drwx------ 11 addison users 4.0K Nov 26 19:40 ..
-rw-r--r--  1 addison users  160 Nov 26 17:03 config
-rw-------  1 addison users    0 Nov 26 17:04 known_hosts
-rw-------  1 addison users  923 Nov 26 17:02 known_hosts.old
-rw-------  1 addison users  420 Nov 26 16:58 kwila
-rw-r--r--  1 addison users  106 Nov 26 16:58 kwila.pub
````

I also added basic SSH config for git hosts in `~/.ssh/config`

```
Host github.com
	HostName github.com
	User git
	IdentityFile ~/.ssh/kwila

Host git.kwila.cloud
	HostName 192.168.31.28
	User git
	IdentityFile ~/.ssh/kwila
```

### Updates

- `u` alias will rebuild

