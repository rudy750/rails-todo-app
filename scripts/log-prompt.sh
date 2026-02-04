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

# Extract the prompt text using grep/sed (handles JSON)
# The input format is: {"prompt":"the user's prompt text"}
PROMPT=$(echo "$INPUT" | sed -n 's/.*"prompt"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')

# If sed didn't work, try a different approach
if [[ -z "$PROMPT" ]]; then
    # Try extracting with grep for multiline or escaped content
    PROMPT=$(echo "$INPUT" | grep -oP '"prompt"\s*:\s*"\K[^"]+' 2>/dev/null || echo "$INPUT")
fi

# Convert escaped newlines to actual newlines for processing
PROMPT=$(echo -e "$PROMPT")

# Strip out <system-reminder>...</system-reminder> blocks using perl (works on macOS)
PROMPT=$(echo "$PROMPT" | perl -0777 -pe 's/<system-reminder>.*?<\/system-reminder>//gs')

# Trim leading/trailing whitespace and blank lines
PROMPT=$(echo "$PROMPT" | sed '/^[[:space:]]*$/d' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

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
