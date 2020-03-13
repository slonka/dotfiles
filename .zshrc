export PATH="/usr/local/bin:$PATH"

# files to source in priority
source ~/.oh-my.zsh

# load zsh config files
config_files=(~/.zsh/**/*.zsh(N))
for file in ${config_files}
do
  source $file
done

#eval "$(direnv hook zsh)"
export NVS_HOME="$HOME/.nvs"
[ -s "$NVS_HOME/nvs.sh" ] && . "$NVS_HOME/nvs.sh"
