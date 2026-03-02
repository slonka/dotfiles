#!/bin/bash
set -e

COMMAND=$(jq -r '.tool_input.command // empty')

if [ -n "$COMMAND" ]; then
  TIMESTAMP=$(date +%s)
  printf ': %s:0;%s\n' "$TIMESTAMP" "$COMMAND" >> ~/.zsh_history
fi
