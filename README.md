# Claude Code Launcher

A simple Bash script launcher for running Claude Code with third-party API providers (Zhipu AI, Kimi, Moonshot, MiniMax, Alibaba Cloud, OpenRouter, Synthetic).

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/agussaas/claude-code-launcher/main/install.sh | bash
```

### What the Installer Does

The install script performs the following steps:

1. **Runs the onboarding skip script** (`claude-code-init.sh`) - Sets `hasCompletedOnboarding: true` in your Claude Code settings so you won't be prompted with the onboarding flow
2. **Installs the launcher** to `~/.local/bin/claude-code-launcher.sh`
3. **Verifies the installation** and checks if `~/.local/bin` is in your PATH

### Configure Before Using

Before running the launcher, you MUST edit the installed script to add your API keys.

```bash
nano ~/.local/bin/claude-code-launcher.sh
```

Find the `API_KEYS` section and replace all `<YOUR_API_KEY>` placeholders with your actual API keys:

```bash
API_KEYS=(
  "Zhipu AI:<YOUR_API_KEY>"
  "Kimi Code:<YOUR_API_KEY>"
  "Moonshot:<YOUR_API_KEY>"
  "MiniMax:<YOUR_API_KEY>"
  "Alibaba Cloud:<YOUR_API_KEY>"
  "OpenRouter:<YOUR_API_KEY>"
  "Synthetic:<YOUR_API_KEY>"
)
```

**Do not run `claude-code-launcher.sh` until you have replaced the placeholder keys.**

## Usage

After installation, run:

```bash
claude-code-launcher.sh
```

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/agussaas/claude-code-launcher/main/uninstall.sh | bash
```

### What the Uninstaller Does

The uninstall script performs the following steps:

1. **Checks for the launcher** at `~/.local/bin/claude-code-launcher.sh`
2. **Confirms removal** with you before proceeding
3. **Removes the launcher** from your system
4. **Verifies the removal** was successful

**Note:** Your Claude Code settings at `~/.claude.json` are not modified.

## Features

- Interactive profile selection (Zhipu AI, Kimi, Moonshot, MiniMax, Alibaba Cloud, OpenRouter, Synthetic)
- Quick default mode or step-by-step setup
- Predefined API profiles
- Runs `claude-code-init.sh` before launch to skip onboarding

## How It Works

This launcher uses **environment variables** to configure Claude Code at runtime:

| Variable | Purpose |
|----------|---------|
| `ANTHROPIC_BASE_URL` | API endpoint URL |
| `ANTHROPIC_API_KEY` / `ANTHROPIC_AUTH_TOKEN` | Authentication |
| `ANTHROPIC_MODEL` | Model to use |
| `ANTHROPIC_*_MODEL` | Override all model variants |

**Important:**
- This approach does **NOT** modify your `~/.claude/settings.json` file
- Settings are **temporary** — only apply to the current Claude session
- Each run prompts you to choose provider/key/model again (or use defaults)

This is useful if you want to quickly switch between different API providers without changing your permanent Claude Code configuration.

## Configuration

**Important:** Before using, edit the predefined profiles in `~/.local/bin/claude-code-launcher.sh`. You can customize the base URLs, API keys, and models:

```bash
# Base URLs
BASE_URLS=(
  "Zhipu AI:zai:https://api.z.ai/api/anthropic"
  "Kimi Code API:kimi:https://api.kimi.com/coding"
  "Moonshot API:moonshot:https://api.moonshot.ai/anthropic"
  "MiniMax:minimax:https://api.minimax.io/anthropic"
  "Alibaba Cloud:alibaba:https://coding-intl.dashscope.aliyuncs.com/apps/anthropic"
  "OpenRouter:openrouter:https://openrouter.ai/api"
  "Synthetic:synthetic:https://api.synthetic.new/anthropic"
)

# API Keys
API_KEYS=(
  "Zhipu AI:<YOUR_API_KEY>"
  "Kimi Code:<YOUR_API_KEY>"
  "Moonshot:<YOUR_API_KEY>"
  "MiniMax:<YOUR_API_KEY>"
  "Alibaba Cloud:<YOUR_API_KEY>"
  "OpenRouter:<YOUR_API_KEY>"
  "Synthetic:<YOUR_API_KEY>"
)

# Models
MODELS=(
  "zai:glm-5"
  "kimi:kimi-k2.5"
  "moonshot:kimi-k2.5"
  "minimax:MiniMax-M2.5"
  "alibaba:glm-5"
  "alibaba:kimi-k2.5"
  "alibaba:MiniMax-M2.5"
  "alibaba:qwen3.5-plus"
  "alibaba:qwen3-max-2026-01-23"
  "alibaba:qwen3-coder-next"
  "alibaba:qwen3-coder-plus"
  "alibaba:glm-4.7"
  "openrouter:z-ai/glm-5"
  "openrouter:moonshotai/kimi-k2.5"
  "openrouter:minimax/minimax-m2.5"
  "openrouter:qwen/qwen3.5-plus-02-15"
  "openrouter:deepseek/deepseek-v3.2"
  "synthetic:hf:zai-org/GLM-4.7"
  "synthetic:hf:MiniMaxAI/MiniMax-M2.5"
  "synthetic:hf:moonshotai/Kimi-K2.5"
  "synthetic:hf:Qwen/Qwen3.5-397B-A17B"
  "synthetic:hf:deepseek-ai/DeepSeek-V3.2"
)
```

## Defaults

When you select **"Use defaults"** in the launcher, it skips the step-by-step setup and uses these default values:

| Variable | Value | Description |
|----------|-------|-------------|
| `DEFAULT_URL=1` | First entry in `BASE_URLS` | Zhipu AI |
| `DEFAULT_KEY=1` | First entry in `API_KEYS` | Zhipu AI |
| `DEFAULT_MODEL=1` | First matching model in `MODELS` | glm-5 |

Change these numbers to select different defaults (e.g., `DEFAULT_URL=2` for Kimi):

```bash
# Defaults
DEFAULT_URL=1
DEFAULT_KEY=1
DEFAULT_MODEL=1
```

## Files

| File | Description |
|------|-------------|
| `install.sh` | One-line installer |
| `uninstall.sh` | Removes the launcher |
| `src/claude-code-init.sh` | Sets `hasCompletedOnboarding: true` |
| `src/claude-code-launcher.sh` | Main launcher with API profiles |

## Requirements

- Bash
- Node.js (for init script)
- Claude Code installed
