#!/bin/bash

# PM Manager Installation Script
# This script installs the PM Manager skill and command for Claude Code

set -e

echo "🚀 Installing PM Manager for Claude Code..."
echo ""

# Get the script's directory (where pm-manager is cloned)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Target directories
SKILLS_DIR="$HOME/.claude/skills/pm-manager"
COMMANDS_DIR="$HOME/.claude/commands"

# Step 1: Check if we're in the right location or need to copy
if [ "$SCRIPT_DIR" != "$SKILLS_DIR" ]; then
    echo "📁 Copying pm-manager to $SKILLS_DIR..."
    mkdir -p "$HOME/.claude/skills"
    cp -r "$SCRIPT_DIR" "$SKILLS_DIR"
    echo "✅ Skill copied to $SKILLS_DIR"
else
    echo "✅ Already in correct location: $SKILLS_DIR"
fi

# Step 2: Make scripts executable
echo "🔧 Making scripts executable..."
chmod +x "$SKILLS_DIR/scripts/"*.sh
echo "✅ Scripts are now executable"

# Step 3: Install command file
echo "📝 Installing /pm command..."
mkdir -p "$COMMANDS_DIR"
cp "$SKILLS_DIR/.claude/commands/pm.md" "$COMMANDS_DIR/pm.md"
echo "✅ Command installed to $COMMANDS_DIR/pm.md"

# Step 4: Verify tmux is installed
echo "🔍 Checking dependencies..."
if ! command -v tmux &> /dev/null; then
    echo "⚠️  WARNING: tmux is not installed. Please install it:"
    echo "   macOS: brew install tmux"
    echo "   Linux: apt-get install tmux or yum install tmux"
else
    echo "✅ tmux is installed"
fi

# Step 5: Verify codex is installed
if ! command -v codex &> /dev/null; then
    echo "⚠️  WARNING: codex CLI is not installed"
    echo "   Install from: https://github.com/airman5573/codex"
else
    echo "✅ codex CLI is installed"
fi

echo ""
echo "🎉 Installation complete!"
echo ""
echo "📋 Next steps:"
echo "1. Add to your project's .claude/settings.local.json:"
echo '   {"permissions": {"allow": ["Skill(pm-manager)"]}}'
echo ""
echo "2. Use the /pm command in Claude Code to start managing developers!"
echo ""
echo "3. The PM Manager will ask: \"무엇을 개발하시겠습니까?\""
echo ""
echo "📚 For more information, see: $SKILLS_DIR/README.md"
