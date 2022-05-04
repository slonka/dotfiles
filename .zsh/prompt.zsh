# customize prompt

source "$(brew --prefix)/opt/kube-ps1/share/kube-ps1.sh"

aws_profile() {
  aws_profile=$(aws configure list | egrep profile | awk '{print "("$2")"}')
  if [[ "${aws_profile}" == "(<not)" ]]
  then
    echo "(none)"
  else
    echo "${aws_profile}"
  fi
}

KUBE_PROMPT='$(kube_ps1)'
AWS_PROMPT='aws:$(aws_profile)'

PS1="
%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} \
%(#,%{$bg[yellow]%}%{$fg[black]%}%n%{$reset_color%},%{$fg[cyan]%}%n) \
%{$reset_color%}@ \
%{$fg[green]%}%m \
%{$reset_color%}in \
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}\
${hg_info}\
${git_info}\
${svn_info}\
${venv_info}\
 $KUBE_PROMPT $AWS_PROMPT \
[%*] $exit_code
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"
