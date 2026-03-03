#!/bin/bash
SESSION_ID=$(jq -r '.session_id // empty')
if [ -n "$SESSION_ID" ] && [ -n "$CLAUDE_SHELL_PID" ]; then
	echo "$SESSION_ID" > "/tmp/claude-session-$CLAUDE_SHELL_PID"
fi
