# customize prompt

# source "$(brew --prefix)/opt/kube-ps1/share/kube-ps1.sh"

# KUBE_PROMPT='$(kube_ps1)'
# AWS_PROMPT='aws:$AWS_PROFILE'

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
[%*] $exit_code
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"

#  $KUBE_PROMPT $AWS_PROMPT \
