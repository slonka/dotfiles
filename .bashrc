set -o vi

for file in ~/.bash/*.bash
do
  . $file
done

export PS1="\[\e[94m\]# \[\e[m\]\[\e[36m\]\u\[\e[m\]\[\e[37m\] @ \[\e[m\]\[\e[32m\]\h\[\e[m\] in \[\e[93m\]\w\[\e[m\]\[\e[36m\]\`parse_git_branch\` \[\e[m\][\t]\n\e[91m$ \e[39m"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
