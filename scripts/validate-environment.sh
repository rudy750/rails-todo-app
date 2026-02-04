#!/bin/bash
# Validate Rails environment on Copilot session start

echo "🔍 Validating Rails Todo App environment..."

# Check Ruby version
REQUIRED_RUBY="3.2.9"
CURRENT_RUBY=$(ruby --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)

if [[ "$CURRENT_RUBY" != "$REQUIRED_RUBY" ]]; then
  echo "⚠️  Warning: Ruby version mismatch. Expected $REQUIRED_RUBY, got $CURRENT_RUBY"
fi

# Check Bundler version
REQUIRED_BUNDLER="2.5.21"
CURRENT_BUNDLER=$(bundle --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unavailable")

if [[ "$CURRENT_BUNDLER" != "$REQUIRED_BUNDLER" ]]; then
  echo "⚠️  Warning: Bundler version mismatch. Expected $REQUIRED_BUNDLER, got $CURRENT_BUNDLER"
  echo "💡 Tip: Use 'bundle _2.5.21_ exec' for commands"
fi

# Check if database exists
if [[ -f "db/development.sqlite3" ]]; then
  echo "✓ Database exists"
else
  echo "⚠️  Database not found. You may need to run: bundle _2.5.21_ exec rails db:create db:migrate"
fi

# Create logs directory if it doesn't exist
mkdir -p logs

echo "✅ Environment validation complete"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Copilot session started" >> logs/copilot-activity.log
