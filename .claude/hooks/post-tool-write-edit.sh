#!/bin/bash
# PostToolUse hook: Auto-format dart files and generate translations
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Auto-format dart files (exclude generated)
if [[ "$FILE_PATH" == *.dart ]] && [[ "$FILE_PATH" != *.g.dart ]] && [[ "$FILE_PATH" != *.freezed.dart ]]; then
  dart format "$FILE_PATH" 2>/dev/null
fi

# Generate translations if translation file was modified
if [[ "$FILE_PATH" == */translations/*.jsonc ]]; then
  PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
  cd "$PROJECT_DIR" && melos run generate_translations 2>/dev/null
fi

# Append to CODEOWNERS for new dart files in packages/
if [[ "$TOOL_NAME" == "Write" ]] && [[ "$FILE_PATH" == */packages/*.dart ]]; then
  PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
  CODEOWNERS_PATH="$PROJECT_DIR/CODEOWNERS"
  if [ -f "$CODEOWNERS_PATH" ]; then
    REL_PATH="${FILE_PATH#$PROJECT_DIR/}"
    if ! grep -q "$REL_PATH" "$CODEOWNERS_PATH" 2>/dev/null; then
      echo "$REL_PATH @$(gh api user -q .login)" >> "$CODEOWNERS_PATH"
    fi
  fi
fi

exit 0
