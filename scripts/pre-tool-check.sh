#!/bin/bash
# Pre-tool use hook - validates and logs tool usage

# Debug: Write to debug log immediately
DEBUG_LOG="/Users/rudy750/dev/learn/ruby-to-do/logs/hook-debug.log"
mkdir -p /Users/rudy750/dev/learn/ruby-to-do/logs
echo "[$(date '+%Y-%m-%d %H:%M:%S')] PRE-TOOL HOOK EXECUTED - PWD: $(pwd)" >> "$DEBUG_LOG"

# Read stdin (JSON input from Copilot)
INPUT=$(cat)

# Log raw input for debugging
echo "[$(date '+%Y-%m-%d %H:%M:%S')] INPUT received: ${INPUT:0:200}..." >> "$DEBUG_LOG"

# Extract tool name from JSON (Claude Code uses "tool_name" field)
TOOL=$(echo "$INPUT" | grep -oE '"tool_name":"[^"]*"' | cut -d'"' -f4)

# Log the tool usage
ACTIVITY_LOG="/Users/rudy750/dev/learn/ruby-to-do/logs/copilot-activity.log"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Pre-tool: $TOOL" >> "$ACTIVITY_LOG"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Logged to activity log: $TOOL" >> "$DEBUG_LOG"

# Check for potentially dangerous operations
if echo "$INPUT" | grep -qE '(rm -rf|DROP TABLE|DELETE FROM|bundle update)'; then
  echo "⚠️  Warning: Potentially destructive operation detected"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ALERT: Destructive operation in $TOOL" >> "$ACTIVITY_LOG"
fi

# Remind to use correct bundler version for Rails commands
if echo "$INPUT" | grep -qE '(rails |rake )' && ! echo "$INPUT" | grep -q 'bundle _2.5.21_ exec'; then
  echo "💡 Remember: This project requires 'bundle _2.5.21_ exec' before Rails commands"
fi

# Always output something to show hook is working
if [[ -z "$TOOL" ]]; then
  echo "✓ Pre-tool check complete (pwd: $(pwd))"
else
  echo "✓ Pre-tool check complete for: $TOOL (pwd: $(pwd))"
fi

# Return success (approve the tool use)
exit 0
