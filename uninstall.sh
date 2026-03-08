#!/bin/bash

# Claude Code Launcher Uninstaller
# Usage: curl -fsSL <raw-url> | bash

set -e

INSTALL_DIR="$HOME/.local/bin"
LAUNCHER_NAME="claude-code-launcher.sh"

# ───────
#  Colors
# ───────
BOLD="\033[1m"
CYAN="\033[1;36m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

echo -e "${CYAN}${BOLD}Claude Code Launcher Uninstaller${RESET}\n"

# ───────────────────
#  Check Installation
# ───────────────────
if [ ! -f "$INSTALL_DIR/$LAUNCHER_NAME" ]; then
    echo -e "${YELLOW}⚠ Launcher not found at $INSTALL_DIR/$LAUNCHER_NAME${RESET}"
    echo -e "Nothing to uninstall.\n"
    exit 0
fi

# ──────────────────
#  Confirm Uninstall
# ──────────────────
echo -e "The following will be removed:"
echo -e "  ${BOLD}$INSTALL_DIR/$LAUNCHER_NAME${RESET}\n"

read -rp "Proceed with uninstall? [y/N]: " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo -e "\n${YELLOW}Uninstall cancelled.${RESET}"
    exit 0
fi

# ────────────────
#  Remove Launcher
# ────────────────
echo -e "\n${CYAN}[1/3] Removing launcher...${RESET}"
if rm -f "$INSTALL_DIR/$LAUNCHER_NAME"; then
    echo -e "  ${GREEN}✓ Removed: $INSTALL_DIR/$LAUNCHER_NAME${RESET}"
else
    echo -e "  ${RED}✗ Failed to remove launcher${RESET}"
    exit 1
fi

# ───────
#  Verify
# ───────
echo -e "\n${CYAN}[2/3] Verifying uninstall...${RESET}"
if [ ! -f "$INSTALL_DIR/$LAUNCHER_NAME" ]; then
    echo -e "  ${GREEN}✓ Uninstall successful!${RESET}"
else
    echo -e "  ${RED}✗ Uninstall failed${RESET}"
    exit 1
fi

# ───────────────────────────
#  Reset Onboarding Setting
# ───────────────────────────
echo -e "\n${CYAN}[3/3] Resetting onboarding setting...${RESET}"
node --eval "
    const os = require('os');
    const path = require('path');
    const fs = require('fs');
    const homeDir = os.homedir();
    const filePath = path.join(homeDir, '.claude.json');
    if (fs.existsSync(filePath)) {
        const content = JSON.parse(fs.readFileSync(filePath, 'utf-8'));
        content.hasCompletedOnboarding = false;
        fs.writeFileSync(filePath, JSON.stringify(content, null, 2), 'utf-8');
        console.log('  Reset hasCompletedOnboarding to false in ~/.claude.json');
    }" 2>/dev/null || echo -e "  ${YELLOW}⚠ Could not reset onboarding setting (Node.js not available)${RESET}"

echo -e "${GREEN}${BOLD}Uninstall Complete!${RESET}\n"
