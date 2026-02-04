# GitHub Copilot Hooks for Rails Todo App

This directory contains hook configurations for GitHub Copilot's coding agent.

## What are hooks?

Hooks allow you to execute custom shell commands at strategic points in Copilot's workflow, such as when a session starts, before tools are used, or when a session ends.

## Installed Hooks

### `rails-hooks.json`

This configuration includes the following hooks:

1. **sessionStart** - Validates your Rails environment
   - Checks Ruby version (expects 3.2.9)
   - Checks Bundler version (expects 2.5.21)
   - Verifies database exists
   - Creates logs directory
   - Logs session start

2. **userPromptSubmitted** - Logs when you submit prompts to Copilot
   - Timestamps each interaction

3. **preToolUse** - Runs before Copilot executes any tool
   - Warns about potentially destructive operations
   - Reminds you to use `bundle _2.5.21_ exec` for Rails commands
   - Logs all tool usage

4. **postToolUse** - Captures tool execution results
   - Saves detailed JSON logs of what Copilot did

5. **sessionEnd** - Logs when the session ends

## Log Files

All activity is logged to the `logs/` directory:
- `logs/copilot-activity.log` - Human-readable session activity
- `logs/tool-usage.jsonl` - JSON-formatted tool execution details

## How to Use

These hooks are automatically used by GitHub Copilot when you interact with the coding agent in this repository. No additional configuration is needed!

## Customization

You can modify the hooks by editing:
- [`.github/hooks/rails-hooks.json`](rails-hooks.json) - Hook configuration
- [`scripts/validate-environment.sh`](../../scripts/validate-environment.sh) - Environment validation logic
- [`scripts/pre-tool-check.sh`](../../scripts/pre-tool-check.sh) - Pre-tool validation logic

## Learn More

- [About hooks](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-hooks)
- [Hooks configuration reference](https://docs.github.com/en/copilot/reference/hooks-configuration)
- [Using hooks with GitHub Copilot agents](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/use-hooks)
