# Set keymapping to VI-mode in zsh
bindkey -v
setopt vi
bindkey "^?" backward-delete-char #Fixes backspace

# Set prompt to GRML. This allows us to customize $RSP manually instead of using :prompt:grml:right:setp
autoload -Uz promptinit
promptinit
prompt grml

# Create a function to detect cmd mode for vi
function zle-line-init zle-keymap-select {
    VIM_PROMPT="[% NORMAL]%"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
    zle reset-prompt
}

# Bind that function. Set the timeout to 0.1
zle -N zle-line-init
zle -N zle-keymap-select
export KEYTIMEOUT=1

# History settings
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt hist_ignore_all_dups inc_append_history

# Completion settings by compinstall
zstyle ':completion:*' expand prefix
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*'
autoload -Uz compinit
compinit

# Source aliases and directory hashes
[[ -f .zshrc.alias.local ]] && source .zshrc.alias.local
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
export TERM=xterm-256color

# Start tmux if available and if interactive. Attach to current session, such that detaching stays possible.
if command -v tmux &> /dev/null && [ -n "$PS1" ]  && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
	# Attach to current session, detaching still possible
	#tmux attach || exec tmux new-session
	# create new session
	exec tmux -2
fi
