grep1() { awk -v pattern="${1:?pattern is empty}" 'NR==1 || $0~pattern' "${2:?filename is empty}"; }

function docker_ips(){
	docker ps -q | xargs -n 1 docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} {{ .Config.Hostname }} {{ .Config.Image }}' | sed 's/ \// /'
}

