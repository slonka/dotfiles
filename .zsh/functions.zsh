grep1() { awk -v pattern="${1:?pattern is empty}" 'NR==1 || $0~pattern' "${2:?filename is empty}"; }

function docker_ips(){
	docker ps -q | xargs -n 1 docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} {{ .Config.Hostname }} {{ .Config.Image }}' | sed 's/ \// /'
}

function git_diff_lines(){
	git diff | gawk '
	  match($0,"^@@ -([0-9]+),([0-9]+) [+]([0-9]+),([0-9]+) @@",a){
	    left=a[1]
	    ll=length(a[2])
	    right=a[3]
	    rl=length(a[4])
	  }
	  /^(---|\+\+\+|[^-+ ])/{ print;next }
	  { line=substr($0,2) }
	  /^[-]/{ printf "-%"ll"s %"rl"s:%s\n",left++,""     ,line;next }
	  /^[+]/{ printf "+%"ll"s %"rl"s:%s\n",""    ,right++,line;next }
	        { printf " %"ll"s %"rl"s:%s\n",left++,right++,line }
	'
}
