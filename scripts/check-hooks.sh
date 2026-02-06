#!/bin/bash
# Check if hooks are working and what data they're receiving

PROJECT_ROOT="/Users/rudy750/dev/learn/ruby-to-do"
DEBUG_LOG="$PROJECT_ROOT/logs/hook-debug.log"
ACTIVITY_LOG="$PROJECT_ROOT/logs/copilot-activity.log"

echo "════════════════════════════════════════════════════"
echo "GitHub Copilot Hooks Status Check"
echo "════════════════════════════════════════════════════"
echo ""

# Check if VS Code hooks are configured
if [[ -f "$PROJECT_ROOT/.vscode/settings.json" ]]; then
    echo "✅ VS Code hooks configuration found"
    echo "   Location: .vscode/settings.json"
    HOOKS_PATH=$(grep -o '"github.copilot.chat.codeGeneration.hooksPath"[^"]*"[^"]*"' "$PROJECT_ROOT/.vscode/settings.json" | cut -d'"' -f4)
    echo "   Hooks file: $HOOKS_PATH"
else
    echo "⚠️  No VS Code hooks configuration found"
fi

echo ""

# Check if hooks file exists
if [[ -f "$PROJECT_ROOT/.github/hooks/rails-hooks.json" ]]; then
    echo "✅ GitHub Copilot hooks file found"
    echo "   Location: .github/hooks/rails-hooks.json"
else
    echo "❌ Hooks file not found!"
fi

echo ""

# Check debug log
if [[ -f "$DEBUG_LOG" ]]; then
    echo "📋 Recent hook activity (last 5 entries):"
    echo ""
    grep "═══ RAW PROMPT INPUT ═══" "$DEBUG_LOG" | tail -n 5
    echo ""
    
    # Check for empty inputs
    EMPTY_COUNT=$(grep -A 1 "═══ RAW PROMPT INPUT ═══" "$DEBUG_LOG" | grep "^{}$" | wc -l | tr -d ' ')
    if [[ $EMPTY_COUNT -gt 0 ]]; then
        echo "⚠️  Found $EMPTY_COUNT instances of empty prompt input ({})"
        echo "   This indicates VS Code Insiders may not be passing prompt data correctly."
        echo ""
    fi
else
    echo "⚠️  No debug log found. Hooks may not have run yet."
fi

# Check activity log
if [[ -f "$ACTIVITY_LOG" ]]; then
    echo "📝 Recent activity (last 10 lines):"
    tail -n 10 "$ACTIVITY_LOG"
else
    echo "⚠️  No activity log found."
fi

echo ""
echo "════════════════════════════════════════════════════"
echo "💡 Tips:"
echo "  - Ask Copilot a question to test the hooks"
echo "  - Check logs/hook-debug.log for detailed debugging"
echo "  - If seeing {}, the VS Code Insiders API may have changed"
echo "════════════════════════════════════════════════════"
