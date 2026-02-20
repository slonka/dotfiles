#!/bin/bash
set -euo pipefail

D=~/projects/dotfiles

# target -> source
links=(
  ~/.zsh                        "$D/.zsh"
  ~/.zshrc                      "$D/.zshrc"
  ~/.oh-my.zsh                  "$D/.oh-my.zsh"
  ~/.tmux.conf                  "$D/.tmux.conf"
  ~/.bashrc                     "$D/.bashrc"
  ~/.bash                       "$D/.bash"
  ~/.sshrc                      "$D/.sshrc"
  ~/.sshrc.d                    "$D/.sshrc.d"
  ~/.gitconfig                  "$D/.gitconfig"
  ~/.gitignore_global           "$D/.gitignore_global"
  ~/.hammerspoon                "$D/.hammerspoon"

  # ghostty
  ~/Library/Application\ Support/com.mitchellh.ghostty/config  "$D/.config/ghostty/config"

  # claude
  ~/.claude/CLAUDE.md              "$D/.claude/CLAUDE.md"
  ~/.claude/settings.json          "$D/.claude/settings.json"
  ~/.claude/notify.sh              "$D/.claude/notify.sh"
  ~/.claude/permission-dialog.sh   "$D/.claude/permission-dialog.sh"
  ~/.claude/statusline-command.sh  "$D/.claude/statusline-command.sh"
  ~/.claude/skills/madr-review     "$D/.claude/skills/madr-review"

  # openwhisper-cleanup
  ~/.config/openwhisper-cleanup/replacements.json  "$D/.config/openwhisper-cleanup/replacements.json"
)

for ((i=0; i<${#links[@]}; i+=2)); do
  target="${links[i]}"
  source="${links[i+1]}"
  mkdir -p "$(dirname "$target")"
  ln -svf "$source" "$target"
done
