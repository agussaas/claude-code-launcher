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
- Automatic API key and model configuration
- Runs `claude-code-init.sh` before launch to skip onboarding

## Files

| File | Description |
|------|-------------|
| `install.sh` | One-line installer |
| `src/claude-code-init.sh` | Sets `hasCompletedOnboarding: true` |
| `src/claude-code-launcher.sh` | Main launcher with API profiles |

## Requirements

- Bash
- Node.js (for init script)
- `claude` CLI installed
