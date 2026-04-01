#!/bin/bash
# PreToolUse hook: Block edits to generated files and secrets
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Block editing generated files
if [[ "$FILE_PATH" == *.g.dart ]] || [[ "$FILE_PATH" == *.freezed.dart ]] || [[ "$FILE_PATH" == *.service.dart ]] || [[ "$FILE_PATH" == */generated/* ]] || [[ "$FILE_PATH" == */build/* ]]; then
  echo "Do not edit generated files. Modify the source and run \`melos run generate_parts\`." >&2
  exit 2
fi

# Block editing secrets
if [[ "$FILE_PATH" == */secrets/* ]]; then
  echo "Never modify secrets/ programmatically." >&2
  exit 2
fi

exit 0
