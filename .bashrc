set -o vi

for file in ~/.bash/*.bash
do
  . $file
done

export PS1="${LIGHT_BLUE}# ${CYAN}\u${RESET} @ ${GREEN}\`hostname -f\`${RESET} in ${BOLD}${LIGHT_YELLOW}\w\`parse_git_branch\`${RESET} [\t]\n${LIGHT_RED}\\$ ${RESET}"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash


source $HOME/.docker/init-bash.sh || true # Added by Docker Desktop

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
