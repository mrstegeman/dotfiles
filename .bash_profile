# include .bashrc if it exists and session is interactive
if [[ -n $PS1 && -f ~/.bashrc ]]; then
    . ~/.bashrc
fi
