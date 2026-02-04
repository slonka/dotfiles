#!/bin/bash
# PermissionRequest hook — interactive notification with Allow/Deny buttons.
# Requires: brew tap kusumotoa/tap && brew install --cask claude-notifier
# Fallback: exits 1 → Claude Code shows normal terminal dialog.

if ! command -v claude-notifier &>/dev/null; then
  exit 1
fi

# Skip notification if user is already focused on this pane
frontmost=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
if [ "$frontmost" = "ghostty" ]; then
  if [ -n "$TMUX" ]; then
    pane_active=$(tmux display-message -p '#{pane_active}')
    window_active=$(tmux display-message -p '#{window_active}')
    if [ "$pane_active" = "1" ] && [ "$window_active" = "1" ]; then
      exit 1
    fi
  else
    exit 1
  fi
fi

payload=$(cat)
tool_name=$(echo "$payload" | jq -r '.tool_name // "Unknown"')
tool_input=$(echo "$payload" | jq -r '.tool_input // empty')

# Shorten a path to its last 2 components (e.g., .claude/permission-dialog.sh)
short_path() { echo "$1" | awk -F/ '{if(NF>2) print $(NF-1)"/"$NF; else print $0}'; }

# Build a human-readable subtitle
case "$tool_name" in
  Bash)
    command_preview=$(echo "$tool_input" | jq -r '.command // empty' | head -c 60)
    detail="Bash: ${command_preview}"
    ;;
  Edit)
    file=$(echo "$tool_input" | jq -r '.file_path // empty')
    detail="Edit: $(short_path "$file")"
    ;;
  Write)
    file=$(echo "$tool_input" | jq -r '.file_path // empty')
    detail="Write: $(short_path "$file")"
    ;;
  NotebookEdit)
    file=$(echo "$tool_input" | jq -r '.notebook_path // empty')
    detail="NotebookEdit: $(short_path "$file")"
    ;;
  *)
    detail="${tool_name}"
    ;;
esac

# Tmux pane focusing logic (reused from notify.sh)
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

# Show blocking notification with Allow/Deny buttons (120s timeout)
response=$(claude-notifier \
  -title "Claude Code" \
  ${subtitle:+-subtitle "$subtitle"} \
  -message "$detail" \
  -actions "Allow,Deny" \
  -timeout 120 \
  "${activate_args[@]}" \
  -sound default \
  -group "claude-permission-$$")

case "$response" in
  Allow)
    echo '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow"}}}'
    exit 0
    ;;
  Deny)
    echo '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"deny","message":"Denied via notification"}}}'
    exit 0
    ;;
  *)
    # Body click, timeout, dismissed — fall through to terminal dialog
    exit 1
    ;;
esac
