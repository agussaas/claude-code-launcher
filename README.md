# Claude Code Launcher

A simple Bash script launcher for running Claude Code with third-party API providers (Kimi, Moonshot, OpenRouter).

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/agussaas/claude-code-launcher/main/install.sh | bash
```

## Usage

After installation, run:

```bash
claude-code-launcher
# or
claude-code-launcher.sh
```

## Features

- Interactive profile selection (Kimi, Moonshot, OpenRouter)
- Quick default mode or step-by-step setup
- Predefined API profiles
- Runs `claude-code-init.sh` before launch to skip onboarding

## Configuration

**Important:** Before using, edit the predefined profiles in `~/.local/bin/claude-code-launcher.sh`. You can customize the base URLs, API keys, and models:

```bash
# Base URLs
BASE_URLS=(
  "Kimi Code API:kimi:https://api.kimi.com/coding"
  "Moonshot API:moonshot:https://api.moonshot.ai/anthropic"
  "OpenRouter:openrouter:https://openrouter.ai/api"
)

# API Keys
API_KEYS=(
  "Kimi:sk-kimi-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  "Moonshot:sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  "OpenRouter:sk-or-v1-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
)

# Models
MODELS=(
  "kimi:kimi-k2.5"
  "moonshot:kimi-k2.5"
  "openrouter:moonshotai/kimi-k2.5"
  "openrouter:minimax/minimax-m2.5"
  "openrouter:z-ai/glm-5"
)
```

## Files

| File | Description |
|------|-------------|
| `install.sh` | One-line installer |
| `src/claude-code-init.sh` | Sets `hasCompletedOnboarding: true` |
| `src/claude-code-launcher.sh` | Main launcher with API profiles |

## Requirements

- Bash
- Node.js (for init script)
- Claude Code installed
