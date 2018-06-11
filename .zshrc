# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="ys"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git git-extras autojump command-not-found dircycle dirhistory last-working-dir lol npm nyan python sudo web-search)

# oh my zsh
source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias vimconfig="vim ~/.vimrc"
alias please='sudo $(fc -ln -1)'

PS1='\[\033[01;31m\][\A] \[\033[01;32m\]\u@\h\[\033[34m\] \w \$\[\033[00m\] '

bindkey -v
bindkey '^R' history-incremental-search-backward

export KEYTIMEOUT=1

# Add indicator when in vi mode
function zle-line-init zle-keymap-select {
    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    RPS2=$RPS1
    zle reset-prompt
}

function read-from-minibuffer {
  emulate -L zsh
  setopt extendedglob

  local opt keys
  integer stat

  while getopts "k:" opt; do
    case $opt in
      # Read the given number of keys.  This is a bit
      # ropey for more than a single key.
      (k)
      keys=$OPTARG
      ;;

      (*)
      return 1
      ;;
    esac
  done
  (( OPTIND > 1 )) && shift $(( OPTIND - 1 ))

  local readprompt="$1" lbuf_init="$2" rbuf_init="$3"
  integer savelim=$UNDO_LIMIT_NO changeno=$UNDO_CHANGE_NO

  {
  # Use anonymous function to make sure special values get restored,
  # even if this function is called as a widget.
  # local +h ensures special parameters stay special.
  () {
    local pretext="$PREDISPLAY$LBUFFER$RBUFFER$POSTDISPLAY
  "
    local +h LBUFFER="$lbuf_init"
    local +h RBUFFER="$rbuf_init"
    local +h PREDISPLAY="$pretext${readprompt:-? }"
    local +h POSTDISPLAY=
    local +h -a region_highlight
    region_highlight=("P${#pretext} ${#PREDISPLAY} bold")

    if [[ -n $keys ]]; then
      zle -R
      read -k $keys
      stat=$?
    else
      local NUMERIC
      unset NUMERIC
      zle split-undo
      UNDO_LIMIT_NO=$UNDO_CHANGE_NO
      zle recursive-edit -K main
      stat=$?
      (( stat )) || REPLY=$BUFFER
    fi
  }
  } always {
    # This removes the edits relating to the read from the undo history.
    # These aren't useful once we get back to the main editing buffer.
    zle undo $changeno
    UNDO_LIMIT_NO=savelim
  }

  return $stat
}
zle -N read-from-minibuffer

# ZSH-SEARCH-BUFFER
function vi-search-buffer-forward {
  emulate -L zsh
  local mbprompt REPLY found
  mbprompt='/'

  # May want to install a custom keymap here
  zle read-from-minibuffer $mbprompt

  found=${(MS)RBUFFER#*$~REPLY}
  # (m) for multibyte characters here, may not be needed
  if [[ -n $found ]]
  then (( CURSOR += ${(m)#found} - ${#REPLY} ))
  fi
}

# ZSH-SEARCH-BUFFER
function vi-search-buffer-backward {
  emulate -L zsh
  local mbprompt REPLY found
  mbprompt='?'

  # May want to install a custom keymap here
  zle read-from-minibuffer $mbprompt

  # found=${(MS)LBUFFER%$~REPLY*}
  found=${(MS)LBUFFER##*$~REPLY}
  # (m) for multibyte characters here, may not be needed
  if [[ -n $found ]]
    then (( CURSOR = ${(m)#found} - ${#REPLY} ))
  fi
}

zle -N vi-search-buffer-forward
zle -N vi-search-buffer-backward

bindkey -a '?' vi-search-buffer-backward
bindkey -a '/' vi-search-buffer-forward

zle -N zle-line-init
zle -N zle-keymap-select

alias amake='make --always-make'
alias tidy-html='tidy -utf8 -i -w 80 -c -q -asxhtml'

alias find-last-modified='find . -type f -printf '"'"'%TY-%Tm-%Td %TT %p\n'"'"' | sort -r | head -n 20'

alias rsynccopy="rsync --partial --progress --append --rsh=ssh -r -h "
alias rsyncmove="rsync --partial --progress --append --rsh=ssh -r -h --remove-sent-files"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

