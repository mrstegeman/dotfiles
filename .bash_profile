if [ "$PROFILE_IMPORTED" != "1" ]; then
    . ~/.profile
fi

# include .bashrc if it exists and session is interactive
if [[ -n $PS1 && -f ~/.bashrc ]]; then
    . ~/.bashrc
fi
