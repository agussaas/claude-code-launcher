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
echo -e "\n${CYAN}[1/2] Removing launcher...${RESET}"
if rm -f "$INSTALL_DIR/$LAUNCHER_NAME"; then
    echo -e "  ${GREEN}✓ Removed: $INSTALL_DIR/$LAUNCHER_NAME${RESET}"
else
    echo -e "  ${RED}✗ Failed to remove launcher${RESET}"
    exit 1
fi

# ───────
#  Verify
# ───────
echo -e "\n${CYAN}[2/2] Verifying uninstall...${RESET}"
if [ ! -f "$INSTALL_DIR/$LAUNCHER_NAME" ]; then
    echo -e "  ${GREEN}✓ Uninstall successful!${RESET}"
else
    echo -e "  ${RED}✗ Uninstall failed${RESET}"
    exit 1
fi

# ─────────────
#  Cleanup Note
# ─────────────
echo -e "\n${YELLOW}Note:${RESET} Your Claude Code settings at ${BOLD}~/.claude.json${RESET} were not modified."
echo -e "If you want to remove the onboarding skip setting, edit that file manually.\n"

echo -e "${GREEN}${BOLD}Uninstall Complete!${RESET}\n"
