#!/bin/bash
# PreToolUse hook: Block dangerous bash operations
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Block git push to protected branches
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
if echo "$COMMAND" | grep -qE 'git push.*(master|beta|release)'; then
  echo "Use feature branches." >&2
  exit 2
fi
if echo "$COMMAND" | grep -qE '^git push' && echo "$CURRENT_BRANCH" | grep -qE '^(master|beta|release)$'; then
  echo "Use feature branches. Currently on $CURRENT_BRANCH." >&2
  exit 2
fi

# Block rm -rf
if echo "$COMMAND" | grep -qE 'rm -rf'; then
  echo "Use targeted delete." >&2
  exit 2
fi

exit 0
