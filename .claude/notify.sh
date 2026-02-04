#!/bin/bash
payload=$(cat)
type=$(echo "$payload" | jq -r '.type // "notification"')

case "$type" in
  permission_prompt) message="Needs permission to continue" ;;
  idle_prompt)       message="Waiting for your input" ;;
  *)                 message="Needs your attention" ;;
esac

terminal-notifier \
  -title "Claude Code" \
  -message "$message" \
  -activate com.mitchellh.ghostty \
  -sound default \
  -group claude-code
