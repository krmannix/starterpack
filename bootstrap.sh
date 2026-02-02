#!/usr/bin/env bash
set -euo pipefail

echo "=================================================="
echo "  macOS Development Environment Bootstrap"
echo "=================================================="
echo

# Check if we're in the right directory
if [ ! -f "flake.nix" ]; then
  echo "Error: Must run this script from the starterpack directory"
  exit 1
fi

REPO_DIR="$(pwd)"

echo "This script will configure machine-specific settings:"
echo "  - Git user configuration"
echo "  - SSH key for GitHub"
echo "  - Claude API key"
echo

# ============================================================================
# Git Configuration
# ============================================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Git Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

read -p "Enter your full name for git: " GIT_NAME
read -p "Enter your email for git: " GIT_EMAIL

# Configure git globally
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

echo "✓ Git configured with:"
echo "  Name:  $GIT_NAME"
echo "  Email: $GIT_EMAIL"
echo

# ============================================================================
# SSH Key Generation
# ============================================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SSH Key for GitHub"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

SSH_KEY="$HOME/.ssh/id_ed25519"

if [ -f "$SSH_KEY" ]; then
  echo "SSH key already exists at $SSH_KEY"
  read -p "Generate a new one? (y/N): " REGEN_SSH
  if [[ ! "$REGEN_SSH" =~ ^[Yy]$ ]]; then
    echo "Skipping SSH key generation"
  else
    ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$SSH_KEY"
    echo "✓ New SSH key generated"
  fi
else
  echo "Generating SSH key..."
  ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$SSH_KEY" -N ""
  echo "✓ SSH key generated at $SSH_KEY"
fi

echo
echo "Starting ssh-agent and adding key..."
eval "$(ssh-agent -s)"
ssh-add "$SSH_KEY"

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Add this SSH key to GitHub:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
cat "$SSH_KEY.pub"
echo
echo "Steps:"
echo "  1. Copy the SSH key above"
echo "  2. Go to https://github.com/settings/ssh/new"
echo "  3. Paste the key and give it a title (e.g., 'MacBook Pro')"
echo "  4. Click 'Add SSH key'"
echo

read -p "Press Enter once you've added the SSH key to GitHub..."

echo
echo "Testing GitHub SSH connection..."
ssh -T git@github.com 2>&1 | head -2 || true
echo

# ============================================================================
# Claude API Key
# ============================================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Claude API Key Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

CLAUDE_DIR="$HOME/.claude"
CLAUDE_CONFIG="$CLAUDE_DIR/config.json"

mkdir -p "$CLAUDE_DIR"

if [ -f "$CLAUDE_CONFIG" ] && grep -q "apiKey" "$CLAUDE_CONFIG" 2>/dev/null; then
  echo "Claude API key already configured in $CLAUDE_CONFIG"
  read -p "Update it? (y/N): " UPDATE_CLAUDE
  if [[ ! "$UPDATE_CLAUDE" =~ ^[Yy]$ ]]; then
    echo "Skipping Claude API key configuration"
    SKIP_CLAUDE=true
  fi
fi

if [ "${SKIP_CLAUDE:-false}" != "true" ]; then
  echo "Get your API key from: https://console.anthropic.com/settings/keys"
  echo
  read -p "Enter your Claude API key (or press Enter to skip): " CLAUDE_API_KEY

  if [ -n "$CLAUDE_API_KEY" ]; then
    cat > "$CLAUDE_CONFIG" <<EOF
{
  "apiKey": "$CLAUDE_API_KEY"
}
EOF
    chmod 600 "$CLAUDE_CONFIG"
    echo "✓ Claude API key configured at $CLAUDE_CONFIG"
  else
    echo "Skipping Claude API key configuration"
  fi
fi

echo

# ============================================================================
# Summary
# ============================================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ Bootstrap Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
echo "Configuration summary:"
echo "  ✓ Git: $GIT_NAME <$GIT_EMAIL>"
echo "  ✓ SSH key: $SSH_KEY"
echo "  $([ -f "$CLAUDE_CONFIG" ] && echo "✓" || echo "⚠") Claude API key"
echo
echo "Next steps:"
echo
echo "  1. Install Nix (if not already installed):"
echo "     curl -L https://nixos.org/nix/install | sh -s -- --daemon"
echo
echo "  2. Move this directory to ~/.config/starterpack:"
echo "     mv \"$REPO_DIR\" ~/.config/starterpack"
echo "     cd ~/.config/starterpack"
echo
echo "  3. Generate flake.lock:"
echo "     nix flake update"
echo
echo "  4. Apply the configuration:"
echo "     nix run nix-darwin -- switch --flake ~/.config/starterpack"
echo
echo "  5. After first run, use:"
echo "     darwin-rebuild switch --flake ~/.config/starterpack"
echo
echo "See README.md for more details."
echo
