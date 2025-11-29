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

The installation uses agenix for secrets management, which requires installing a pre-generated SSH host key.

### Deployment Command

From the `hosts/dev-server` directory:

```bash
just deploy-dev-server <target-ip>
```

Example:

```bash
just deploy-dev-server 192.168.31.246
```

The justfile recipe automatically:
- Prepares the SSH host key for installation
- Runs nixos-anywhere with the correct parameters
- Cleans up temporary files

**After deployment:** Remove the installer DVD in ProxMox hardware options before rebooting.

### Updates

- `u` alias will rebuild

