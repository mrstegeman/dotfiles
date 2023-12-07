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
    if [ "$(uname -s)" = "Darwin" ]; then
        export CLICOLOR=YES

        if ! which gls >/dev/null 2>&1; then
            export LSCOLORS=ExGxFxdaCxDaDahbadacec
        fi
    fi
fi

# colors for less
export LESS='-R -c -i'
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
