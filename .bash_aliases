# some good aliases
alias quit='exit'
alias date='date "+%A, %B %d, %Y   %R:%S"'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias extip="wget -qO - http://www.whatismyip.com/automation/n09230945.asp && echo"
alias tracklist="ls -R -1"
alias renew="sudo dhclient eth0"
alias vidmerge="mencoder -forceidx -oac copy -ovc copy -o"
alias vga-off="xrandr --output VGA --off"
alias vga-on="xrandr --output VGA --mode 1280x1024"
alias upgrade="yaourt -Syyu --aur --devel"

# Extract files from any archive
# Usage: extract <archive_name>

extract () {
    for file in "$@"
    do
        if [ -f "$file" ] ; then
            case "$file" in
                *.tar.bz2) tar xjf "$file" ;;
                *.tar.gz) tar xzf "$file" ;;
                *.bz2) bunzip2 "$file" ;;
                *.rar) unrar x "$file" ;;
                *.gz) gunzip "$file" ;;
                *.tar) tar xf "$file" ;;
                *.tbz2) tar xjf "$file" ;;
                *.tgz) tar xzf "$file" ;;
                *.zip) unzip "$file" ;;
                *.jar) unzip "$file" ;;
                *.Z) uncompress "$file" ;;
                *.7z) 7z x "$file" ;;
                *.lzma) unlzma "$file" ;;
                *) echo "'$file' cannot be extracted via extract()" ;;
            esac
        else
            echo "'$file' is not a valid file"
        fi
    done
}
