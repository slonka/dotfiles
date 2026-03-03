grep1() { awk -v pattern="${1:?pattern is empty}" 'NR==1 || $0~pattern' "${2:?filename is empty}"; }

function docker_ips(){
	docker ps -q | xargs -n 1 docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} {{ .Config.Hostname }} {{ .Config.Image }}' | sed 's/ \// /'
}

function git_diff_lines(){
	git diff $1 | gawk '
	BEGIN {
		filepath = ""
	}
	/^---/ {
		sub(/^--- a\//, "", $0)
		oldfile = $0
		next
	}
	/^\+\+\+/ {
		sub(/^\+\+\+ b\//, "", $0)
		filepath = $0
		printf "File: %s\n", filepath
		next
	}
	match($0,"^@@ -([0-9]+),([0-9]+) [+]([0-9]+),([0-9]+) @@",a){
		left=a[1]
		ll=length(a[2])
		right=a[3]
		rl=length(a[4])
	}
	/^(---|\+\+\+|[^-+ ])/{ print; next }
	{ line=substr($0,2) }
	/^[-]/{ printf "-%"ll"s %"rl"s:%s:%s\n",left++,""     ,filepath,line; next }
	/^[+]/{ printf "+%"ll"s %"rl"s:%s:%s\n",""    ,right++,filepath,line; next }
			{ printf " %"ll"s %"rl"s:%s:%s\n",left++,right++,filepath,line }
	'
}

claude() {
	# Skip resume prompt for non-interactive modes
	case " $* " in
		*" -p "* | *" --print "*) command claude "$@"; return ;;
	esac

	CLAUDE_SHELL_PID=$$ command claude "$@"

	local session_id
	session_id=$(cat /tmp/claude-session-$$ 2>/dev/null)
	rm -f /tmp/claude-session-$$
	[[ -z "$session_id" ]] && return

	local model
	model=$(printf "opus\nsonnet\nhaiku" | fzf --prompt="Model: " --height=~5 --reverse --no-info)
	[[ -z "$model" ]] && return

	print -z "claude --model $model --resume $session_id --fork-session"
}

reload-all() {
	local pane cmd pid
	tmux list-panes -a -F '#{pane_id} #{pane_current_command} #{pane_pid}' | while read -r pane cmd pid; do
		case "$cmd" in
			zsh|bash|sh)
				tmux send-keys -t "$pane" "source ~/.zshrc" Enter
				;;
			*)
				if pgrep -P "$pid" -f claude > /dev/null 2>&1; then
					tmux send-keys -t "$pane" "!source ~/.zshrc" Enter
				fi
				;;
		esac
	done
}

function remove_changed_lines(){
	while true; do
		matches=$(git_diff_lines --staged | grep -E '^\+[^+]' | grep "$1" | head -n 1)
		echo "matches: $matches"

		if [[ -z $matches ]]; then
			break
		fi

		echo "$matches" | awk -F: '{sub(/^\+ */, "", $1); print $2, $1}' | while IFS=' ' read -r filepath line; do
			echo "Deleting line $line in file $filepath"
			gsed -i "${line}d" "$filepath"
			git add .
		done
	done
}
