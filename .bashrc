# If not running interactively, don't do anything
[ -z "$PS1" ] && return

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

if [ "$(uname -s)" = "Darwin" ]; then
    HOMEBREW_PREFIX=""
    if [ -d "/opt/brew" ]; then
        HOMEBREW_PREFIX="/opt/brew"
    elif [ -d "/opt/homebrew" ]; then
        HOMEBREW_PREFIX="/opt/homebrew"
    elif [ -d "/usr/local" ]; then
        HOMEBREW_PREFIX="/usr/local"
    fi
fi

# enable programmable completion features
if [ -r /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -r /usr/local/share/bash-completion/bash_completion ]; then
    . /usr/local/share/bash-completion/bash_completion
elif [ -r /etc/bash_completion ]; then
    . /etc/bash_completion
elif [ -r "${HOMEBREW_PREFIX}/etc/bash_completion" ]; then
    . "${HOMEBREW_PREFIX}/etc/bash_completion"
elif [ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]; then
    . "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
fi

if [ -r /usr/share/git/completion/git-prompt.sh ]; then
    . /usr/share/git/completion/git-prompt.sh
elif [ -d /Applications/Xcode.app/Contents/Developer/usr/share/git-core ]; then
    . /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash
    . /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh
else
    if [ ! -d /tmp/.bash.git-completion ]; then
        mkdir /tmp/.bash.git-completion
        curl \
            -s -S -L \
            -o /tmp/.bash.git-completion/git-completion.bash \
            "https://raw.githubusercontent.com/git/git/refs/heads/master/contrib/completion/git-completion.bash"
        curl \
            -s -S -L \
            -o /tmp/.bash.git-completion/git-prompt.sh \
            "https://raw.githubusercontent.com/git/git/refs/heads/master/contrib/completion/git-prompt.sh"
    fi

    . /tmp/.bash.git-completion/git-completion.bash
    . /tmp/.bash.git-completion/git-prompt.sh
fi

if [ -d /etc/bash_completion.d ]; then
    for completion in /etc/bash_completion.d/*; do
        [[ -r "${completion}" ]] && source "${completion}"
    done
elif [ -d "${HOMEBREW_PREFIX}/etc/bash_completion.d" ]; then
    for completion in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
        [[ -r "${completion}" ]] && source "${completion}"
    done
elif [ -d "${HOMEBREW_PREFIX}/opt/git/etc/bash_completion.d" ]; then
    for completion in "${HOMEBREW_PREFIX}/opt/git/etc/bash_completion.d/"*; do
        [[ -r "${completion}" ]] && source "${completion}"
    done
fi

__custom_git_ps1() {
    if ! type __git_ps1 >/dev/null 2>&1; then
        return
    fi

    __ps1=$(__git_ps1 | sed -e 's/)//' -e 's/(//' -e 's/ //')

    if [ "$__ps1" = "" ]; then
        return
    fi

    changes=$(git status --porcelain 2>/dev/null | wc -l | awk '{ print $1 }')
    if [ "$changes" = "0" ]; then
        printf "─[\e[0;32m$__ps1\e[0m]"
    else
        printf "─[\e[0;31m$__ps1\e[0m]"
    fi
}

# locale
export LC_COLLATE=C
export LC_CTYPE=en_US.UTF-8

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
    HOMEBREW_PREFIX=""
    if [ -d "/opt/brew" ]; then
        HOMEBREW_PREFIX="/opt/brew"
    elif [ -d "/opt/homebrew" ]; then
        HOMEBREW_PREFIX="/opt/homebrew"
    elif [ -d "/usr/local" ]; then
        HOMEBREW_PREFIX="/usr/local"
    fi

    export HOMEBREW_INSTALL_CLEANUP=1
    export HOMEBREW_NO_ANALYTICS=1

    # man pages
    [ -d "${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnuman" ] && \
        export MANPATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnuman:$MANPATH"

    # homebrew
    [ -d "${HOMEBREW_PREFIX}/bin" ] && export PATH="${HOMEBREW_PREFIX}/bin:$PATH"
    [ -d "${HOMEBREW_PREFIX}/sbin" ] && export PATH="${HOMEBREW_PREFIX}/sbin:$PATH"

    # gnu utils
    [ -d "${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin" ] && \
        export PATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin:$PATH"
    [ -d "${HOMEBREW_PREFIX}/opt/findutils/libexec/gnubin" ] && \
        export PATH="${HOMEBREW_PREFIX}/opt/findutils/libexec/gnubin:$PATH"
    [ -d "${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin" ] && \
        export PATH="${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin:$PATH"
    [ -d "${HOMEBREW_PREFIX}/opt/gnu-tar/libexec/gnubin" ] && \
        export PATH="${HOMEBREW_PREFIX}/opt/gnu-tar/libexec/gnubin:$PATH"
fi

# enable color support of ls and grep, set PS1
if [ "$TERM" != "dumb" ]; then
    PS1="┌──[\e[0;33m\u\e[0m@\e[0;34m\h\e[0m]─[\e[2;37m\w\e[0m]\$(__custom_git_ps1)\n└─\$ "

    if [ "$(uname -s)" = "Darwin" ]; then
        export CLICOLOR=YES
    fi

    if type dircolors >/dev/null 2>&1; then
        if [ -f ~/.dircolors ]; then
            eval "`dircolors -b ~/.dircolors`"
        else
            eval "`dircolors -b`"
        fi
    fi

    if [ "$(uname -s)" = "Darwin" ]; then
        if [ -z "$(which gls)" ]; then
            export LSCOLORS=ExGxFxdaCxDaDahbadacec
            alias ls='ls --color=auto -Av'
        else
            alias ls='gls --color=auto -Av --ignore=.DS_Store --ignore=.localized'
        fi
    elif [ "$(uname -s)" = "OpenBSD" ]; then
        if [ -n "$(which colorls)" ]; then
            export LSCOLORS=ExGxFxdaCxDaDahbadacec
            alias ls='colorls -AG'
        elif [ -n "$(which gls)" ]; then
            alias ls='gls --color=auto -Av --ignore=.DS_Store --ignore=.localized'
        else
            alias ls='ls -AF'
        fi
    else
        alias ls='ls --color=auto -Av --ignore=.DS_Store --ignore=.localized'
    fi

    if [ "$(uname -s)" = "OpenBSD" ]; then
        if [ -n "$(which ggrep)" ]; then
            alias grep='ggrep --color=auto'
            alias egrep='gegrep --color=auto'
        fi

        alias pcregrep='pcregrep --color=auto'
    elif [ "$(readlink $(which grep))" != "busybox" ]; then
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
export LESS='-R -c -i'
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# alias definitions.
if [ -f ~/.sh_aliases ]; then
    . ~/.sh_aliases
fi

# extra, private stuff
[ -f ~/.sh_extra ] && . ~/.sh_extra || true
