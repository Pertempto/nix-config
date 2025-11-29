# Setup SSH Client Key for Dev Server

This guide walks through generating and encrypting the SSH client key for the dev-server.

## Prerequisites

- Nix installed (works on any machine, not just NixOS)
- Working directory: `nix-config/hosts/dev-server`

## Steps

### 1. Generate the SSH Client Key

```bash
ssh-keygen -t ed25519 -f /tmp/dev-server-client -C "addison@dev-server" -N ""
```

### 2. Copy the Private Key to Clipboard (save in password manager)

```bash
# X11
cat /tmp/dev-server-client | xclip -selection clipboard

# Wayland
cat /tmp/dev-server-client | wl-copy
```

**ACTION:** The private key is now in your clipboard. Paste it into your password manager under "dev-server SSH client key". Your password manager can generate the public key from the private key when needed.

### 3. Encrypt the Private Key with Agenix

```bash
nix run github:ryantm/agenix -- -e secrets/client-key.age
```

When the editor opens, paste the **private key contents** from step 2, save and exit.

### 4. Verify the Encrypted File Was Created

```bash
ls -lh secrets/client-key.age
```

You should see the encrypted file.

### 5. Clean Up Temporary Files

```bash
rm /tmp/dev-server-client /tmp/dev-server-client.pub
```

### 6. Commit and Deploy

```bash
cd ../..
git add hosts/dev-server/secrets.nix hosts/dev-server/configuration.nix hosts/dev-server/secrets/client-key.age
git commit -m "feat: add SSH client key for dev-server"
```

Then deploy to dev-server using your normal deployment process.

## After Deployment

The private key will be automatically placed at `/home/addison/.ssh/id_ed25519` on the dev-server with proper ownership (addison) and permissions (0600).

To use it to SSH to other servers, add the public key to `~/.ssh/authorized_keys` on those servers.

## Notes

- The encrypted `.age` file is safe to commit to your public repo
- Only machines with the dev-server host key can decrypt it
- Keep the private key in your password manager as a backup
