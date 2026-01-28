# starterpack

Consistent setup for my macOS machines.

## Quick Start

1. Install Nix
```bash
curl -L https://nixos.org/nix/install | sh -s -- --daemon
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

2. Clone this repo:
```bash
git clone git@github.com:krmannix/starterpack ~/.config/starterpack
cd ~/.config/starterpack
```

3. Update hostname in `flake.nix`:
```bash
scutil --get LocalHostName  # Check your hostname
# Edit flake.nix line 13 to match: darwinConfigurations."your-hostname"
```

4. Run bootstrap script:
```bash
./bootstrap.sh
```

### Initial Run Installation

After cloning and running bootstrap, apply the nix-darwin configuration:

```bash
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake /Users/kevin/.config/starterpack
```

## Updates

### Create an update

Edit any file in `~/.config/starterpack/`, then apply:

```bash
darwin-rebuild switch --flake ~/.config/starterpack
```

Some configs are copied rather than symlinked. After editing them in place, sync back to the repo:

```bash
nix-sync
```

Review changes, commit, and push up.

## Pull an update

```bash
cd ~/.config/starterpack
git pull
darwin-rebuild switch --flake ~/.config/starterpack
```

## What's managed?

- CLI tools
- Language environment managers
- Terminals, Browsers, and utility apps like Alfred
- Zsh configuration
- Git aliases & settings
- Cursor/VSCode settings
- iTerm2 preferences
- Claude settings + `~/CLAUDE.md`
- Git user name and email
- SSH keys
- Claude API key
