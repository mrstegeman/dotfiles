# locale
export LC_COLLATE=C

# programs
export EDITOR=vim
export VISUAL=$EDITOR
export BROWSER=google-chrome-stable
export PAGER=less

# path
export PATH=$HOME/bin:/opt/depot_tools-svn:$PATH

# include .bashrc if it exists and session is interactive
if [[ -n $PS1 && -f ~/.bashrc ]]; then
    . ~/.bashrc
fi
