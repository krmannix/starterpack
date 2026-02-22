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

CURRENT_GIT_NAME=$(git config --global user.name 2>/dev/null || true)
CURRENT_GIT_EMAIL=$(git config --global user.email 2>/dev/null || true)

if [ -n "$CURRENT_GIT_NAME" ] || [ -n "$CURRENT_GIT_EMAIL" ]; then
  echo "Git already configured:"
  echo "  Name:  $CURRENT_GIT_NAME"
  echo "  Email: $CURRENT_GIT_EMAIL"
  read -p "Update git configuration? (y/N): " UPDATE_GIT
  if [[ ! "$UPDATE_GIT" =~ ^[Yy]$ ]]; then
    echo "Keeping existing git configuration"
    GIT_NAME="$CURRENT_GIT_NAME"
    GIT_EMAIL="$CURRENT_GIT_EMAIL"
    SKIP_GIT=true
  fi
fi

if [ "${SKIP_GIT:-false}" != "true" ]; then
  read -p "Enter your full name for git${CURRENT_GIT_NAME:+ [$CURRENT_GIT_NAME]}: " GIT_NAME_INPUT
  read -p "Enter your email for git${CURRENT_GIT_EMAIL:+ [$CURRENT_GIT_EMAIL]}: " GIT_EMAIL_INPUT

  GIT_NAME="${GIT_NAME_INPUT:-$CURRENT_GIT_NAME}"
  GIT_EMAIL="${GIT_EMAIL_INPUT:-$CURRENT_GIT_EMAIL}"

  if [ -n "$GIT_NAME" ] && [ -n "$GIT_EMAIL" ]; then
    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"
    echo "✓ Git configured with:"
    echo "  Name:  $GIT_NAME"
    echo "  Email: $GIT_EMAIL"
  else
    echo "Skipping git configuration (name or email empty)"
  fi
fi
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
  echo "SSH key already exists at $SSH_KEY, skipping generation"
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
# Gemini API Key
# ============================================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Gemini API Key Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

SECRETS_FILE="$HOME/.config/zsh/.zshrc.d/secrets.zsh"

if grep -q "GEMINI_API_KEY" "$SECRETS_FILE" 2>/dev/null; then
  echo "Gemini API key already configured in $SECRETS_FILE"
  read -p "Update it? (y/N): " UPDATE_GEMINI
  if [[ ! "$UPDATE_GEMINI" =~ ^[Yy]$ ]]; then
    echo "Skipping Gemini API key configuration"
    SKIP_GEMINI=true
  fi
fi

if [ "${SKIP_GEMINI:-false}" != "true" ]; then
  echo "Get your API key from: https://aistudio.google.com/apikey"
  echo
  read -p "Enter your Gemini API key (or press Enter to skip): " GEMINI_API_KEY_INPUT

  if [ -n "$GEMINI_API_KEY_INPUT" ]; then
    mkdir -p "$(dirname "$SECRETS_FILE")"
    touch "$SECRETS_FILE"
    if grep -q "GEMINI_API_KEY" "$SECRETS_FILE" 2>/dev/null; then
      sed -i '' "s|^export GEMINI_API_KEY=.*|export GEMINI_API_KEY=\"$GEMINI_API_KEY_INPUT\"|" "$SECRETS_FILE"
    else
      echo "export GEMINI_API_KEY=\"$GEMINI_API_KEY_INPUT\"" >> "$SECRETS_FILE"
    fi
    chmod 600 "$SECRETS_FILE"
    echo "✓ Gemini API key configured at $SECRETS_FILE"
  else
    echo "Skipping Gemini API key configuration"
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
echo "  $(grep -q "GEMINI_API_KEY" "$SECRETS_FILE" 2>/dev/null && echo "✓" || echo "⚠") Gemini API key"
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
