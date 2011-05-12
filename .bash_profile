# locale
export LC_COLLATE=C

# programs
export EDITOR=vim
export VISUAL=$EDITOR
export BROWSER=firefox
export PAGER=less

# path
export PATH=$HOME/bin:$PATH

# include .bashrc if it exists and session is interactive
if [ -n $PS1 && -f ~/.bashrc ]; then
    . ~/.bashrc
fi
