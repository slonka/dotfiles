#!/bin/bash

# Skip notification if user is already focused on this pane
frontmost=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
if [ "$frontmost" = "ghostty" ]; then
  if [ -n "$TMUX" ]; then
    pane_active=$(tmux display-message -p '#{pane_active}')
    window_active=$(tmux display-message -p '#{window_active}')
    if [ "$pane_active" = "1" ] && [ "$window_active" = "1" ]; then
      exit 0
    fi
  else
    exit 0
  fi
fi

payload=$(cat)
type=$(echo "$payload" | jq -r '.type // "notification"')

case "$type" in
  idle_prompt) message="Waiting for your input" ;;
  *)           message="Needs your attention" ;;
esac

activate_args=()
subtitle=""
if [ -n "$TMUX" ]; then
  tmux_session=$(tmux display-message -p '#S')
  tmux_window=$(tmux display-message -p '#I')
  tmux_pane=$(tmux display-message -p '#P')
  tmux_client=$(tmux display-message -p '#{client_name}')
  subtitle=$(tmux display-message -p '#S:#I.#P #{window_name}')
  tmux=/opt/homebrew/bin/tmux
  activate_cmd="${tmux} select-window -t '${tmux_session}:${tmux_window}'; ${tmux} select-pane -t '${tmux_session}:${tmux_window}.${tmux_pane}'; ${tmux} switch-client -c '${tmux_client}' -t '${tmux_session}:${tmux_window}'; open -a Ghostty"
  activate_args=(-execute "$activate_cmd")
fi

if command -v claude-notifier &>/dev/null; then
  claude-notifier \
    -title "Claude Code" \
    ${subtitle:+-subtitle "$subtitle"} \
    -message "$message" \
    -timeout 30 \
    "${activate_args[@]}" \
    -sound default \
    -group "claude-code-$$"
else
  terminal-notifier \
    -title "Claude Code" \
    ${subtitle:+-subtitle "$subtitle"} \
    -message "$message" \
    ${activate_args:+"${activate_args[@]}"} \
    -sound default \
    -group "claude-code-$$"
fi
