#!/bin/bash
# Log user prompts from Claude Code userPromptSubmit hook
# This script reads JSON from stdin and extracts the prompt

PROJECT_ROOT="/Users/rudy750/dev/learn/ruby-to-do"
PROMPT_LOG="$PROJECT_ROOT/logs/prompts.log"
DEBUG_LOG="$PROJECT_ROOT/logs/hook-debug.log"

# Ensure logs directory exists
mkdir -p "$PROJECT_ROOT/logs"

# Read the JSON input from stdin
INPUT=$(cat)

# Log raw input for debugging (includes system-reminder data)
echo "[$(date '+%Y-%m-%d %H:%M:%S')] ═══ RAW PROMPT INPUT ═══" >> "$DEBUG_LOG"
echo "$INPUT" >> "$DEBUG_LOG"
echo "" >> "$DEBUG_LOG"

# Create a temporary Python script to extract and clean the prompt
PYTHON_SCRIPT=$(mktemp)
cat > "$PYTHON_SCRIPT" << 'PYEND'
import json
import os
import re
import sys

raw = sys.stdin.read()

def pick_value(obj, keys):
    if not isinstance(obj, dict):
        return ""
    for key in keys:
        val = obj.get(key)
        if isinstance(val, str) and val.strip():
            return val
    return ""

def from_messages(messages):
    if not isinstance(messages, list):
        return ""
    for item in reversed(messages):
        if not isinstance(item, dict):
            continue
        role = item.get("role") or item.get("speaker") or item.get("type")
        if role in ("user", "human", "User", "Human") or role is None:
            val = pick_value(item, ["content", "text", "message", "prompt", "input"])
            if isinstance(item.get("content"), list):
                for chunk in item.get("content"):
                    if isinstance(chunk, dict):
                        text = pick_value(chunk, ["text", "content", "message"])
                        if text:
                            val = text
                            break
            if val:
                return val
    return ""

def strip_system_reminders(text):
    """Remove <system-reminder>...</system-reminder> blocks from text"""
    if not isinstance(text, str):
        return text
    # Remove system-reminder blocks (handles escaped newlines in JSON)
    text = re.sub(r'<system-reminder>[\s\S]*?</system-reminder>', '', text)
    # Remove extra newlines and leading/trailing whitespace
    text = re.sub(r'\n\s*\n+', '\n', text)
    return text.strip()

prompt = ""
data = {}

try:
    if raw.strip():
        data = json.loads(raw)
except Exception:
    data = {}

if isinstance(data, dict):
    prompt = pick_value(data, ["prompt", "userPrompt", "message", "input", "query", "text", "content"])

    if not prompt:
        prompt = from_messages(data.get("messages") or data.get("history") or data.get("conversation"))

    if not prompt:
        for key in ("data", "event", "payload"):
            if isinstance(data.get(key), dict):
                prompt = pick_value(data[key], ["prompt", "userPrompt", "message", "input", "query", "text", "content"])
                if prompt:
                    break

    if not prompt:
        transcript_path = data.get("transcript_path") or data.get("transcriptPath") or data.get("transcript") or data.get("transcript_file")
        if isinstance(transcript_path, str) and transcript_path and os.path.exists(transcript_path):
            try:
                with open(transcript_path, "r", encoding="utf-8") as handle:
                    lines = handle.readlines()[-200:]
                for line in reversed(lines):
                    line = line.strip()
                    if not line:
                        continue
                    try:
                        entry = json.loads(line)
                    except Exception:
                        continue
                    prompt = pick_value(entry, ["prompt", "message", "text", "content", "input"])
                    if not prompt:
                        prompt = from_messages(entry.get("messages") or entry.get("history") or entry.get("conversation"))
                    if prompt:
                        break
            except Exception:
                pass

if not prompt:
    for env_key in ("COPILOT_PROMPT", "GITHUB_COPILOT_PROMPT", "USER_PROMPT", "PROMPT", "CHAT_PROMPT"):
        env_val = os.environ.get(env_key, "")
        if env_val.strip():
            prompt = env_val
            break

if not prompt and len(sys.argv) > 1:
    prompt = " ".join(sys.argv[1:])

if prompt:
    try:
        prompt = bytes(prompt, "utf-8").decode("unicode_escape")
    except Exception:
        pass

# Strip system-reminder blocks from the prompt before returning
prompt = strip_system_reminders(prompt)

print(prompt)
PYEND

# Extract the prompt using the Python script
PROMPT=$(echo "$INPUT" | python3 "$PYTHON_SCRIPT" 2>/dev/null)
rm "$PYTHON_SCRIPT"

# Trim leading/trailing whitespace
PROMPT=$(echo "$PROMPT" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

# Skip logging if prompt is empty after stripping
if [[ -z "$PROMPT" ]]; then
    echo "No user prompt to log"
    exit 0
fi

# Get timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Log the prompt to prompts.log
echo "═══════════════════════════════════════════════════════════════" >> "$PROMPT_LOG"
echo "[$TIMESTAMP]" >> "$PROMPT_LOG"
echo "$PROMPT" >> "$PROMPT_LOG"
echo "" >> "$PROMPT_LOG"

# Also log full prompt to copilot-activity.log
echo "───────────────────────────────────────────────────────────────" >> "$PROJECT_ROOT/logs/copilot-activity.log"
echo "[$TIMESTAMP] USER PROMPT:" >> "$PROJECT_ROOT/logs/copilot-activity.log"
echo "$PROMPT" >> "$PROJECT_ROOT/logs/copilot-activity.log"
echo "" >> "$PROJECT_ROOT/logs/copilot-activity.log"

# Output success message (shown in system-reminder)
echo "Prompt logged successfully"

exit 0

