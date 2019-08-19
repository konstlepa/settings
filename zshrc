#!/usr/bin/env zsh

#
# PARAMS
#
HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=500
DIRSTACKSIZE=7

#
# OPTIONS
#
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt NO_BEEP
setopt EXTENDED_GLOB
setopt HIST_LEX_WORDS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt INTERACTIVE_COMMENTS
setopt RM_STAR_SILENT
setopt LONG_LIST_JOBS
setopt OCTAL_ZEROES
setopt POSIX_ALIASES
setopt CSH_JUNKIE_HISTORY
setopt PROMPT_SUBST
setopt NO_LIST_AMBIGUOUS
setopt GLOB_COMPLETE
setopt COMPLETE_IN_WORD
setopt RC_EXPAND_PARAM
setopt RC_QUOTES
setopt TRANSIENT_RPROMPT
setopt COMPLETE_ALIASES
setopt NULL_GLOB

#
# BINDINGS
#
bindkey -e
bindkey '^t' push-line-or-edit

autoload edit-command-line
zle -N edit-command-line
bindkey '^x' edit-command-line

zmodload zsh/complist
bindkey -M listscroll q send-break
bindkey -M menuselect '^o' accept-and-menu-complete

#
# COMPLETIONS
#
autoload -U +X compinit && compinit

zstyle ':completion:*' verbose true
zstyle ':completion:*' list-separator '#'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' insert-tab pending
zstyle ':completion:*' rehash true

zstyle ':completion:*:default' list-prompt '%SAt %p: Hit <TAB> for more, or the character to insert, or <q> to exit%s'
zstyle ':completion:*:default' menu 'select=0'
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:windows' menu 'on=0'

zstyle ':completion::*:::' completer _expand _complete _prefix
zstyle ':completion:*:prefix:*' add-space true

zstyle ':completion:*' group-name ''

zstyle ':completion:*:descriptions' format '%B%d%b'

zstyle ':completion:*:expand:*' tag-order 'all-expansions original'
zstyle ':completion:*:expand:*' substitute true
zstyle ':completion:*:expand:*' accept-exact continue

zstyle ':completion:*' ignore-parents parent pwd

zstyle ':completion:*:*files' ignored-patterns '*?.(o|swp|pyc|pyo)' '*?~'
zstyle ':completion:*:*:cd:*' ignored-patterns '(*/|)CVS'

zstyle ':completion::*:(-command-|export):*' fake-parameters LD_LIBRARY_PATH

# Load every completion after autocomplete loads.
for file in ~/.zcompletions/*; do
	source "$file"
done

fpath=(~/.zfunctions $fpath)
for file in ~/.zfunctions/*; do
	autoload +X "$file"
done

#
# TMUX CONFIGURATION
#
function start_tmux() {
	tmux_default_exec=$(command -v tmux)
	if [ -z "$TMUX_EXEC" ]; then
		TMUX_EXEC=$tmux_default_exec
	fi

	if [ ! -x "$TMUX_EXEC" ] || [ -z "$TMUX_AUTOSTART" ]; then
		return
	fi

	autoload -U add-zsh-hook
	add-zsh-hook preexec update_env_with_tmux

	function update_env_with_tmux() {
		local tmux_sock=default
		if [ -n "$TMUX_VSCODE_SOCK" ]; then
			tmux_sock=vscode
		fi

		if [ -n "$TMUX" ]; then
			eval $($TMUX_EXEC -L $tmux_sock show-environment -s)
		fi
	}

	if [ -n "$TMUX" ]; then
		return
	fi

	local tmux_sock=default
	local tmux_sess=$($TMUX_EXEC -L $tmux_sock list-sessions -F '#{session_name}' | head -n1)
	if [ -z "$tmux_sess" ]; then
		tmux_sess=0
	fi

	if [ -n "$TMUX_VSCODE_SOCK" ]; then
		tmux_sock=vscode
		tmux_sess=$(basename `pwd` | tr -dc '[:alnum:]-')-$(pwd | shasum | cut -c1-5)
	fi

	exec $TMUX_EXEC -L $tmux_sock new-session -AD -s $tmux_sess
}

start_tmux
unfunction start_tmux
