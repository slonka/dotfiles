# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository for macOS. Configs are symlinked from `~/projects/dotfiles/` to `~` — there is no install script, just manual `ln -svf` commands (see `readme.md`).

## Setup

Clone to `~/projects/dotfiles` and symlink each config file/directory to home. Full list in `readme.md`.

## Architecture

### Shell (Zsh — primary)

- Uses Oh-My-Zsh framework (`ys` theme, plugins: git, autojump, docker)
- `.zshrc` sources all modules from `.zsh/` directory
- Modular files in `.zsh/`: `aliases.zsh`, `config.zsh`, `functions.zsh`, `prompt.zsh`, `vimode.zsh`, `path.zsh`, `node.zsh`, `k8s.zsh`, `osx.zsh`, `vscode.zsh`, `extras.zsh`
- Vi-mode editing enabled with visual indicator in prompt
- Tool version management via `mise`

### Shell (Bash — secondary)

- `.bashrc` sources modules from `.bash/` (`colors.bash`, `prompt.bash`)
- Simpler setup, mostly for fallback/compatibility

### SSH remote environment

- `.sshrc` and `.sshrc.d/` provide consistent shell environment on remote servers via the `sshrc` tool
- Includes its own prompt, colors, vim config, FZF support, and history sync

### Tmux

- `.tmux.conf` — prefix remapped to `Ctrl-A`, vi-mode navigation (hjkl), solarized dark theme, 10M line history

### Git

- `.gitconfig` — SSH commit signing enabled, default branch `main`, fast-forward only pulls

### Hammerspoon (macOS automation)

- `.hammerspoon/init.lua` — `Cmd+J` toggles/cycles Ghostty terminal windows

## Conventions

- Shell modules are organized by concern (one file per topic in `.zsh/` and `.bash/`)
- PATH additions go in `.zsh/path.zsh`
- New shell aliases go in `.zsh/aliases.zsh`
- New shell functions go in `.zsh/functions.zsh`
- Kubernetes-related config goes in `.zsh/k8s.zsh`
- Node/version-manager setup goes in `.zsh/node.zsh`
