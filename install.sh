#!/bin/bash

# Claude Code Launcher Installer
# Usage: curl -fsSL <raw-url> | bash

set -e

REPO_URL="https://github.com/agussaas/claude-code-launcher"
INSTALL_DIR="$HOME/.local/bin"
LAUNCHER_NAME="claude-code-launcher.sh"

# Colors
BOLD="\033[1m"
CYAN="\033[1;36m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

echo -e "${CYAN}${BOLD}Claude Code Launcher Installer${RESET}\n"

# Create install directory
if ! mkdir -p "$INSTALL_DIR" 2>/dev/null; then
    echo -e "${RED}Failed to create $INSTALL_DIR${RESET}"
    exit 1
fi

# Check if directory is writable
if [ ! -w "$INSTALL_DIR" ]; then
    echo -e "${RED}Error: No write permission to $INSTALL_DIR${RESET}"
    exit 1
fi

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo -e "${YELLOW}Warning: $INSTALL_DIR is not in your PATH${RESET}"
    echo -e "Add the following to your shell config (~/.bashrc, ~/.zshrc, etc.):\n"
    echo -e "  ${BOLD}export PATH=\"\$HOME/.local/bin:\$PATH\"${RESET}\n"
fi

# Determine how we were called to find the source files
if [ -n "$BASH_SOURCE" ] && [ -f "$BASH_SOURCE" ]; then
    # Running from local file
    SCRIPT_DIR="$(cd "$(dirname "$BASH_SOURCE")" && pwd)"
    SRC_DIR="$SCRIPT_DIR/src"
else
    # Running from curl - download the scripts
    echo -e "${CYAN}Downloading scripts from repository...${RESET}"
    TMP_DIR=$(mktemp -d)
    trap "rm -rf $TMP_DIR" EXIT

    curl -fsSL "$REPO_URL/raw/main/src/claude-code-init.sh" -o "$TMP_DIR/claude-code-init.sh" || {
        echo -e "${RED}Failed to download init script from $REPO_URL${RESET}"
        exit 1
    }
    curl -fsSL "$REPO_URL/raw/main/src/claude-code-launcher.sh" -o "$TMP_DIR/claude-code-launcher.sh" || {
        echo -e "${RED}Failed to download launcher script from $REPO_URL${RESET}"
        exit 1
    }

    SRC_DIR="$TMP_DIR"
fi

# Step 1: Run init script first
echo -e "${CYAN}[1/3] Running initialization...${RESET}"
if [ -f "$SRC_DIR/claude-code-init.sh" ]; then
    bash "$SRC_DIR/claude-code-init.sh"
    echo -e "  ${GREEN}✓ Initialization complete${RESET}"
else
    echo -e "  ${YELLOW}⚠ Init script not found, skipping${RESET}"
fi

# Step 2: Install launcher script
echo -e "\n${CYAN}[2/3] Installing launcher to $INSTALL_DIR...${RESET}"
if [ -f "$SRC_DIR/claude-code-launcher.sh" ]; then
    cp "$SRC_DIR/claude-code-launcher.sh" "$INSTALL_DIR/$LAUNCHER_NAME"
    chmod +x "$INSTALL_DIR/$LAUNCHER_NAME"
    echo -e "  ${GREEN}✓ Installed: $INSTALL_DIR/$LAUNCHER_NAME${RESET}"
else
    echo -e "  ${RED}✗ Launcher script not found${RESET}"
    exit 1
fi

# Step 3: Verify
echo -e "\n${CYAN}[3/3] Verifying installation...${RESET}"
if [ -x "$INSTALL_DIR/$LAUNCHER_NAME" ]; then
    echo -e "  ${GREEN}✓ Installation successful!${RESET}"
else
    echo -e "  ${RED}✗ Installation failed${RESET}"
    exit 1
fi

# Create symlink without .sh so both commands work
if [ ! -e "$INSTALL_DIR/claude-code-launcher" ]; then
    if ln -sf "$INSTALL_DIR/$LAUNCHER_NAME" "$INSTALL_DIR/claude-code-launcher" 2>/dev/null; then
        echo -e "  ${GREEN}✓ Created symlink: claude-code-launcher${RESET}"
    fi
fi

# Final message
echo -e "\n${GREEN}${BOLD}Installation Complete!${RESET}"
echo -e "\nYou can now run either:"
echo -e "  ${BOLD}claude-code-launcher${RESET}"
echo -e "  ${BOLD}claude-code-launcher.sh${RESET}"

# Check PATH again
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo -e "\n${YELLOW}Remember to add $INSTALL_DIR to your PATH:${RESET}"
    echo -e "  ${BOLD}export PATH=\"\$HOME/.local/bin:\$PATH\"${RESET}"
    echo -e "\nThen reload your shell:"
    echo -e "  ${BOLD}source ~/.bashrc${RESET}  (or ~/.zshrc)"
fi
