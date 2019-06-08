#!/usr/bin/env zsh

ulimit -c unlimited

alias ls='ls -F'

export LC_MESSAGES="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export FTP_PASSIVE_MODE=1
export GPG_TTY=$(tty)
export EDITOR="vi"
export VISUAL=$EDITOR
export PROMPT='$ '

if [ -n "$TMUX_VSCODE_SOCK" ]; then
	export EDITOR="code --wait"
	export VISUAL=$EDITOR
fi

path=(~/.local/bin /sbin /usr/sbin /usr/local/bin /usr/bin $path)

if test -f "$HOME/.zshenv.local"; then
	source $HOME/.zshenv.local
fi
