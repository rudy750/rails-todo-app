#!/bin/bash
# Pre-tool use hook - validates and logs tool usage

# Read stdin (JSON input from Copilot)
INPUT=$(cat)

# Extract tool name from JSON (simple grep approach)
TOOL=$(echo "$INPUT" | grep -oE '"tool":"[^"]*"' | cut -d'"' -f4)

# Log the tool usage
mkdir -p logs
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Pre-tool: $TOOL" >> logs/copilot-activity.log

# Check for potentially dangerous operations
if echo "$INPUT" | grep -qE '(rm -rf|DROP TABLE|DELETE FROM|bundle update)'; then
  echo "⚠️  Warning: Potentially destructive operation detected"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ALERT: Destructive operation in $TOOL" >> logs/copilot-activity.log
fi

# Remind to use correct bundler version for Rails commands
if echo "$INPUT" | grep -qE '(rails |rake )' && ! echo "$INPUT" | grep -q 'bundle _2.5.21_ exec'; then
  echo "💡 Remember: This project requires 'bundle _2.5.21_ exec' before Rails commands"
fi

# Return success (approve the tool use)
exit 0
