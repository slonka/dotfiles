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
