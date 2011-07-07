# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# set some nice options
shopt -s checkwinsize cmdhist dotglob histappend no_empty_cmd_completion

# notify of completed background jobs immediately
set -o notify

# turn off control character echoing
stty -ctlecho

# history stuff
HISTIGNORE="&:ls:exit:reset:clear"
HISTCONTROL="ignoreboth:erasedups"
HISTSIZE=1000000
HISTFILESIZE=1000000000
export ${!HIST@}

PS1='\u@\h:\w\$ '

# if this is an xterm set the title to user@host:dir
# merge history from all sessions
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}:${PWD/$HOME/~}\007";history -a'
    ;;
*)
    PROMPT_COMMAND="history -a"
    ;;
esac

# alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable color support of ls and grep
if [ "$TERM" != "dumb" ]; then
    if [ -f ~/.dircolors ]; then
        eval "`dircolors -b ~/.dircolors`"
    else
        eval "`dircolors -b`"
    fi
    alias ls='ls --color=auto -A'
    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
    alias zgrep='zgrep --color=auto'
    alias pcregrep='pcregrep --color=auto'
fi

# enable programmable completion features
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

LESS=-R
LESS_TERMCAP_mb=$'\E[01;31m'
LESS_TERMCAP_md=$'\E[01;31m'
LESS_TERMCAP_me=$'\E[0m'
LESS_TERMCAP_se=$'\E[0m'                           
LESS_TERMCAP_so=$'\E[01;44;33m'                                 
LESS_TERMCAP_ue=$'\E[0m'
LESS_TERMCAP_us=$'\E[01;32m'
export ${!LESS@}
