#!/bin/bash
payload=$(cat)
type=$(echo "$payload" | jq -r '.type // "notification"')

case "$type" in
  idle_prompt) message="Waiting for your input" ;;
  *)           message="Needs your attention" ;;
esac

subtitle=""
activate=(-activate com.mitchellh.ghostty)
if [ -n "$TMUX" ]; then
  tmux_session=$(tmux display-message -p '#S')
  tmux_window=$(tmux display-message -p '#I')
  tmux_pane=$(tmux display-message -p '#P')
  tmux_client=$(tmux display-message -p '#{client_name}')
  subtitle=$(tmux display-message -p '#S:#I.#P #{window_name}')
  tmux=/opt/homebrew/bin/tmux
  activate=(-execute "${tmux} select-window -t '${tmux_session}:${tmux_window}'; ${tmux} select-pane -t '${tmux_session}:${tmux_window}.${tmux_pane}'; ${tmux} switch-client -c '${tmux_client}' -t '${tmux_session}:${tmux_window}'; open -a Ghostty")
fi

terminal-notifier \
  -title "Claude Code" \
  ${subtitle:+-subtitle "$subtitle"} \
  -message "$message" \
  "${activate[@]}" \
  -sound default \
  -group "claude-code-$$"
