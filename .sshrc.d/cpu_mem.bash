# --------------------------------

COLOR_OK=$GREEN
COLOR_WARN=$YELLOW
COLOR_CRIT=$RED
COLOR_NONE=$RESET

function print_bar() {
    BAR_WIDTH=20
    prcntg=$1
    warn=$2
    crit=$3
    bar_color=$COLOR_OK
    if [ $prcntg -gt $warn ]; then
        bar_color=$COLOR_WARN
    fi
    if [ $prcntg -gt $crit ]; then
        bar_color=$COLOR_CRIT
    fi

    bar_width_fill=$((BAR_WIDTH * prcntg / 100))
    bar_width_empty=$((BAR_WIDTH - bar_width_fill))

    printf -v bar "%${bar_width_fill}s" ""
    printf -v nbar "%${bar_width_empty}s" ""
    printf "${bar_color}"
    printf '%3d%% %s' "$prcntg" "${bar// /█}"
    printf "${COLOR_NONE}"
    printf '%s' "${nbar// /▒}"
}

function print_cpu() {
    #
    # cpu usage
    #
    cpu_cores=$(cat /proc/cpuinfo | grep "processor" | wc -l)
    i=0
    cpu_out_1=($(cat /proc/stat | grep "cpu"))
    # the longer we sleep the more accurate is the calculated percentage
    sleep 0.3
    cpu_out_2=($(cat /proc/stat | grep "cpu"))

    cpu_out_colcount=($(cat /proc/stat | head -n 1))
    cpu_out_colcount=${#cpu_out_colcount[@]}

    while [ $i -lt $cpu_cores ]; do
        cpu_index=$(($i * $cpu_out_colcount + $cpu_out_colcount + 1))
        cpu_load_1=(${cpu_out_1[@]:$cpu_index:4})
        cpu_load_2=(${cpu_out_2[@]:$cpu_index:4})
        cpu_sum_1=$((cpu_load_1[0] + cpu_load_1[1] + cpu_load_1[2] + cpu_load_1[3]))
        cpu_sum_2=$((cpu_load_2[0] + cpu_load_2[1] + cpu_load_2[2] + cpu_load_2[3]))
        cpu_sum_diff=$((cpu_sum_2 - cpu_sum_1))
        cpu_idle_1=${cpu_load_1[3]}
        cpu_idle_2=${cpu_load_2[3]}
        cpu_idle_diff=$((cpu_idle_2 - cpu_idle_1))
        cpu_perc=$((100 - (100 * $cpu_idle_diff / $cpu_sum_diff)))
        printf "${COLOR_HEADER}"
        printf '  CPU %-2d ' "$i"
        printf "${COLOR_NONE}"
        print_bar $cpu_perc 30 60
        printf "\n"
        i=$((i+1));
    done;
}

function print_mem() {
    used_mem=$(free -m | awk 'NR==2{printf "%3.0f", $3*100/$2 }')
    printf "  MEM    "
    print_bar $used_mem 30 60
    printf "\n"
}

if [[ -f /proc/cpuinfo && /proc/stat ]]; then
    print_cpu
else
    echo "No cpu info available"
fi

if [ -x "$(command -v free)" ]; then
    print_mem
else
    echo "No mem info available"
fi

