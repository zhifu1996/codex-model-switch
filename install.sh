#!/bin/bash
# Codex Model Switch Installer
# This script installs or updates codex-model-switch

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME=".codex-model-switch-bin"
UNINSTALL_NAME="codex-model-switch-uninstall"
BASHRC="$HOME/.bashrc"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}      Codex Model Switch Installer${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Create install directory if not exists
mkdir -p "$INSTALL_DIR"

# Copy main script (as hidden file)
echo -e "${YELLOW}Installing codex-model-switch...${NC}"
cp "$SCRIPT_DIR/codex-model-switch" "$INSTALL_DIR/$SCRIPT_NAME"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
echo -e "  Installed: $INSTALL_DIR/$SCRIPT_NAME"

# Copy uninstall script
echo -e "${YELLOW}Installing uninstall script...${NC}"
cp "$SCRIPT_DIR/uninstall.sh" "$INSTALL_DIR/$UNINSTALL_NAME"
chmod +x "$INSTALL_DIR/$UNINSTALL_NAME"
echo -e "  Installed: $INSTALL_DIR/$UNINSTALL_NAME"

# Shell function wrapper
FUNC_MARKER="# Codex Model Switch - shell wrapper"
SHELL_FUNCTION='# Codex Model Switch - shell wrapper
codex-model-switch() {
    ~/.local/bin/.codex-model-switch-bin "$@"
    return $?
}'

# Check if function already exists in bashrc
if grep -q "$FUNC_MARKER" "$BASHRC" 2>/dev/null; then
    echo -e "${YELLOW}Updating shell function...${NC}"
    # Remove old function (from marker to closing brace)
    sed -i "/$FUNC_MARKER/,/^}/d" "$BASHRC"
fi

# Add shell function to bashrc
echo "" >> "$BASHRC"
echo "$SHELL_FUNCTION" >> "$BASHRC"
echo -e "${GREEN}Added 'codex-model-switch' function to ~/.bashrc${NC}"

# Ensure ~/.local/bin is in PATH
if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
    if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$BASHRC"; then
        echo "" >> "$BASHRC"
        echo '# Add local bin to PATH' >> "$BASHRC"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$BASHRC"
        echo -e "${GREEN}Added $INSTALL_DIR to PATH in ~/.bashrc${NC}"
    fi
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Usage:"
echo "  1. Run 'source ~/.bashrc' to reload your shell"
echo "  2. Use 'codex-model-switch' to switch models"
echo ""
echo "To update later, run this script again from the project directory."
echo "To uninstall, run: $UNINSTALL_NAME"
