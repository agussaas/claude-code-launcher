#!/bin/bash

# ────────────────────
#  Predefined Profiles
# ────────────────────

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

# ─────────
#  Defaults
# ─────────
DEFAULT_URL=1
DEFAULT_KEY=1
DEFAULT_MODEL=1

# ────────
#  Helpers
# ────────
BOLD="\033[1m"
CYAN="\033[1;36m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

pick() {
  local title="$1"
  local default="$2"; shift 2
  local options=("$@")
  echo -e "\n${CYAN}${BOLD}${title}${RESET}"
  for i in "${!options[@]}"; do
    if [[ $((i+1)) -eq $default ]]; then
      echo -e "  ${YELLOW}$((i+1)))${RESET} ${options[$i]} ${GREEN}[default]${RESET}"
    else
      echo -e "  ${YELLOW}$((i+1)))${RESET} ${options[$i]}"
    fi
  done
  while true; do
    read -rp $'\n'"Choose [1-${#options[@]}] or Enter for default: " choice
    if [[ -z "$choice" ]]; then
      PICK_RESULT="${options[$((default-1))]}"
      return
    fi
    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#options[@]} )); then
      PICK_RESULT="${options[$((choice-1))]}"
      return
    fi
    echo -e "  ${RED}Invalid choice, try again.${RESET}"
  done
}

# ────────
#  Startup
# ────────
pick "Claude Code Launcher:" 1 "Use defaults" "Step-by-step setup"

if [[ "$PICK_RESULT" == "Use defaults" ]]; then
  USE_DEFAULTS=true
else
  USE_DEFAULTS=false
fi

if [[ "$USE_DEFAULTS" == true ]]; then
  # Resolve defaults directly without prompting
  _url_entry="${BASE_URLS[$((DEFAULT_URL-1))]}"
  _url_rest="${_url_entry#*:}"
  PROVIDER="${_url_rest%%:*}"
  BASE_URL="${_url_rest#*:}"

  _key_entry="${API_KEYS[$((DEFAULT_KEY-1))]}"
  API_KEY="${_key_entry#*:}"

  # Pick first model for the resolved provider
  FILTERED_MODELS=()
  for entry in "${MODELS[@]}"; do
    if [[ "${entry%%:*}" == "$PROVIDER" ]]; then
      FILTERED_MODELS+=("${entry#*:}")
    fi
  done
  MODEL="${FILTERED_MODELS[0]}"

else
  # ─────────
  #  Base URL
  # ─────────
  URL_LABELS=()
  for entry in "${BASE_URLS[@]}"; do
    URL_LABELS+=("${entry%%:*}")
  done
  URL_LABELS+=("Custom")

  pick "Select BASE URL:" "$DEFAULT_URL" "${URL_LABELS[@]}"
  SELECTED_URL_LABEL="$PICK_RESULT"

  if [[ "$SELECTED_URL_LABEL" == "Custom" ]]; then
    read -rp "Enter custom base URL: " BASE_URL
    PROVIDER="custom"
  else
    for entry in "${BASE_URLS[@]}"; do
      LABEL="${entry%%:*}"
      if [[ "$LABEL" == "$SELECTED_URL_LABEL" ]]; then
        REST="${entry#*:}"
        PROVIDER="${REST%%:*}"
        BASE_URL="${REST#*:}"
        break
      fi
    done
  fi

  # ────────
  #  API Key
  # ────────
  KEY_LABELS=()
  for entry in "${API_KEYS[@]}"; do
    KEY_LABELS+=("${entry%%:*}")
  done
  KEY_LABELS+=("Custom")

  pick "Select API KEY:" "$DEFAULT_KEY" "${KEY_LABELS[@]}"
  SELECTED_KEY_LABEL="$PICK_RESULT"

  if [[ "$SELECTED_KEY_LABEL" == "Custom" ]]; then
    read -rp "Enter custom API key: " API_KEY
  else
    for entry in "${API_KEYS[@]}"; do
      if [[ "${entry%%:*}" == "$SELECTED_KEY_LABEL" ]]; then
        API_KEY="${entry#*:}"
        break
      fi
    done
  fi

  # ──────
  #  Model
  # ──────
  FILTERED_MODELS=()
  for entry in "${MODELS[@]}"; do
    if [[ "${entry%%:*}" == "$PROVIDER" ]]; then
      FILTERED_MODELS+=("${entry#*:}")
    fi
  done
  FILTERED_MODELS+=("Custom")

  if [[ ${#FILTERED_MODELS[@]} -eq 1 ]]; then
    echo -e "\n${YELLOW}No preset models for provider '${PROVIDER}'. Enter manually.${RESET}"
    read -rp "Enter model name: " MODEL
  else
    pick "Select MODEL:" "$DEFAULT_MODEL" "${FILTERED_MODELS[@]}"
    if [[ "$PICK_RESULT" == "Custom" ]]; then
      read -rp "Enter custom model name: " MODEL
    else
      MODEL="$PICK_RESULT"
    fi
  fi
fi

# ────────
#  Summary
# ────────
echo -e "\n${CYAN}${BOLD}Configuration${RESET}"
echo -e "  ${BOLD}PROVIDER :${RESET} $PROVIDER"
echo -e "  ${BOLD}BASE URL :${RESET} $BASE_URL"
echo -e "  ${BOLD}API KEY  :${RESET} ${API_KEY:0:16}"
echo -e "  ${BOLD}MODEL    :${RESET} $MODEL"

read -rp $'\nProceed? [Y/n]: ' confirm
if [[ "$confirm" =~ ^[Nn] ]]; then
  echo "Aborted."
  exit 0
fi

# ────────────────
#  Export & Launch
# ────────────────
export ANTHROPIC_BASE_URL="$BASE_URL"
export ANTHROPIC_MODEL="$MODEL"
export ANTHROPIC_SMALL_FAST_MODEL="$MODEL"
export ANTHROPIC_DEFAULT_OPUS_MODEL="$MODEL"
export ANTHROPIC_DEFAULT_SONNET_MODEL="$MODEL"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="$MODEL"
export CLAUDE_CODE_SUBAGENT_MODEL="$MODEL"

if [[ "$PROVIDER" == "openrouter" || "$PROVIDER" == "zai" || "$PROVIDER" == "minimax" || "$PROVIDER" == "alibaba" || "$PROVIDER" == "synthetic" ]]; then
  export ANTHROPIC_AUTH_TOKEN="$API_KEY"
  export ANTHROPIC_API_KEY="" # Important: Must be explicitly empty
else
  export ANTHROPIC_API_KEY="$API_KEY"
fi

export API_TIMEOUT_MS="3000000"
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
export CLAUDE_CODE_DISABLE_AUTOUPDATES=1

claude
