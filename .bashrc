# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# extra, private stuff
[ -f ~/.bash_extra ] && . ~/.bash_extra

# set some nice options
shopt -s checkwinsize cmdhist dotglob histappend no_empty_cmd_completion
if shopt | grep -q globstar; then
    shopt -s globstar
fi

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

# enable programmable completion features
if [ -r /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -r /etc/bash_completion ]; then
    . /etc/bash_completion
elif [ -r /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
elif [ -r /opt/brew/etc/bash_completion ]; then
    . /opt/brew/etc/bash_completion
elif [ -d /etc/bash_completion.d ]; then
    for file in $(find /etc/bash_completion.d -maxdepth 1 -type f); do
        . "${file}"
    done
fi

if [ -r /usr/share/git/completion/git-prompt.sh ]; then
    . /usr/share/git/completion/git-prompt.sh
fi

if [ -d /usr/local/opt/git/etc/bash_completion.d ]; then
    for file in $(find /usr/local/opt/git/etc/bash_completion.d -maxdepth 1 -type f); do
        . "${file}"
    done
elif [ -d /opt/brew/opt/git/etc/bash_completion.d ]; then
    for file in $(find /opt/brew/opt/git/etc/bash_completion.d -maxdepth 1 -type f); do
        . "${file}"
    done
fi

__custom_git_ps1()
{
    if ! type __git_ps1 >/dev/null 2>&1; then
        return
    fi

    __ps1=$(__git_ps1 | sed -e 's/)//' -e 's/(//' -e 's/ //')

    if [ "$__ps1" = "" ]; then
        return
    fi

    changes=$(git status --porcelain 2>/dev/null | wc -l)
    if [ "$changes" = "0" ]; then
        printf "─[\e[0;32m$__ps1\e[0m]"
    else
        printf "─[\e[0;31m$__ps1\e[0m]"
    fi
}

# enable color support of ls and grep, set PS1
if [ "$TERM" != "dumb" ]; then
    PS1="┌──[\e[0;33m\u\e[0m@\e[0;34m\h\e[0m]─[\e[2;37m\w\e[0m]\$(__custom_git_ps1)\n└─\$ "

    if [ $(uname) = "Darwin" ]; then
        export CLICOLOR=YES
    fi

    if type dircolors >/dev/null 2>&1; then
        if [ -f ~/.dircolors ]; then
            eval "`dircolors -b ~/.dircolors`"
        else
            eval "`dircolors -b`"
        fi
    fi

    alias ls='ls --color=auto -Av --ignore=.DS_Store --ignore=.localized'

    _link=$(readlink $(which grep))
    if [ "$_link" != "busybox" ]; then
        alias grep='grep --color=auto'
        alias egrep='egrep --color=auto'
        alias zgrep='zgrep --color=auto'
        alias pcregrep='pcregrep --color=auto'
    fi
else
    PS1='┌──[\u@\h]─[\w]\n└─\$ '
    alias ls='ls -Av'
fi

complete -cf sudo

# colors for less
LESS='-R -c -i'
LESS_TERMCAP_mb=$'\E[01;31m'
LESS_TERMCAP_md=$'\E[01;31m'
LESS_TERMCAP_me=$'\E[0m'
LESS_TERMCAP_se=$'\E[0m'                           
LESS_TERMCAP_so=$'\E[01;44;33m'                                 
LESS_TERMCAP_ue=$'\E[0m'
LESS_TERMCAP_us=$'\E[01;32m'
export ${!LESS@}

# locale
export LC_COLLATE=C

# programs
export EDITOR=vim
export VISUAL=$EDITOR
export BROWSER=firefox
export PAGER=less

# path
export PATH="$HOME/bin:$PATH"
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"
[ -d "$HOME/node_modules/.bin" ] && export PATH="$HOME/node_modules/.bin:$PATH"

export GPG_TTY=$(tty)

# platform-specific
if [ "$(uname -s)" = "Darwin" ]; then
    export HOMEBREW_INSTALL_CLEANUP=1
    export HOMEBREW_NO_ANALYTICS=1

    [ -d "/usr/local/opt/coreutils/libexec/gnuman" ] && \
        export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
    [ -d "/opt/brew/opt/coreutils/libexec/gnuman" ] && \
        export MANPATH="/opt/brew/opt/coreutils/libexec/gnuman:$MANPATH"

    [ -d "/usr/local/bin" ] && export PATH="/usr/local/bin:$PATH"
    [ -d "/usr/local/sbin" ] && export PATH="/usr/local/sbin:$PATH"
    [ -d "/opt/brew/bin" ] && export PATH="/opt/brew/bin:$PATH"
    [ -d "/opt/brew/sbin" ] && export PATH="/opt/brew/sbin:$PATH"
fi
