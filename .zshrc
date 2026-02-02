export PATH="/usr/local/bin:$PATH"

# files to source in priority
source ~/.oh-my.zsh

# load zsh config files
config_files=(~/.zsh/**/*.zsh(N))
for file in ${config_files}
do
  source $file
done

source <(fzf --zsh)

export PATH="$HOME/.kuma-dev/kuma-master/bin/:$PATH"

export PATH=/opt/homebrew/opt/python@3.9/libexec/bin:$PATH
export PATH="$HOME/Library/Python/3.9/bin:$PATH"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
eval "$(mise activate zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/bin/google-cloud-sdk/path.zsh.inc' ]; then . '$HOME/bin/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '$HOME/bin/google-cloud-sdk/completion.zsh.inc' ]; then . '$HOME/bin/google-cloud-sdk/completion.zsh.inc'; fi

# Created by `pipx` on 2025-10-27 05:12:03
export PATH="$PATH:$HOME/.local/bin"
