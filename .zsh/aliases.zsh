alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias vimconfig="vim ~/.vimrc"
alias please='sudo $(fc -ln -1)'
alias json2yaml="python -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)'"

alias amake='make --always-make'
alias tidy-html='tidy -utf8 -i -w 80 -c -q -asxhtml'
alias find-last-modified='find . -type f -printf '"'"'%TY-%Tm-%Td %TT %p\n'"'"' | sort -r | head -n 20'
alias rsynccopy="rsync --partial --progress --append --rsh=ssh -r -h "
alias rsyncmove="rsync --partial --progress --append --rsh=ssh -r -h --remove-sent-files"