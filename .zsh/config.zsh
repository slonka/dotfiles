# Highlight the current autocomplete option
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Better SSH/Rsync/SCP Autocomplete
zstyle ':completion:*:(scp|rsync):*' tag-order ' hosts:-ipaddr:ip\ address hosts:-host:host files'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# Allow for autocomplete to be case insensitive
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
  '+l:|?=** r:|?=**'

# add completion for sshrc
compdef sshrc=ssh

# Initialize the autocompletion
autoload -Uz compinit && compinit -i

# bind keys
bindkey -v
bindkey '^R' history-incremental-search-backward

setopt HIST_IGNORE_ALL_DUPS

export KEYTIMEOUT=1
export GROOVY_HOME=/usr/local/opt/groovysdk/libexec
export GOBIN=$HOME/go/bin

export ASYNC_PROFILER_DIR=$HOME/src/async-profiler
export FLAME_GRAPH_DIR=$HOME/src/FlameGraph

export GROOVY_HOME=/usr/local/opt/groovy/libexec
