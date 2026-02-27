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

## Defaults

When you select **"Use defaults"** in the launcher, it skips the step-by-step setup and uses these default values:

| Variable | Value | Description |
|----------|-------|-------------|
| `DEFAULT_URL=1` | First entry in `BASE_URLS` | Kimi Code API |
| `DEFAULT_KEY=1` | First entry in `API_KEYS` | Kimi |
| `DEFAULT_MODEL=1` | First matching model in `MODELS` | kimi-k2.5 |

Change these numbers to select different defaults (e.g., `DEFAULT_URL=2` for Moonshot):

```bash
# Defaults
DEFAULT_URL=1 # https://api.kimi.com/coding
DEFAULT_KEY=1 # sk-kimi-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
DEFAULT_MODEL=1 # kimi-k2.5
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
