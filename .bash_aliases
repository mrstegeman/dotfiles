# some good aliases
alias date='date "+%A, %B %d, %Y   %R:%S"'
alias extip="wget -qO - http://www.whatismyip.com/automation/n09230945.asp && echo"
alias vidmerge="mencoder -forceidx -oac copy -ovc copy -o"
alias vga-off="xrandr --output VGA --off"
alias vga-on="xrandr --output VGA --mode 1280x1024"
alias upgrade="yaourt -Syyu --aur --devel"
alias vimdiff='vimdiff -c "set wrap" -c "wincmd w" -c "set wrap"'
# vim habits...
alias :q="exit"
alias :wq="exit"

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

# make directory and change to it
mkcd() {
    [[ $1 ]] || return 0
    [[ ! -d $1 ]] && mkdir -vp "$1"
    [[ -d $1 ]] && builtin cd "$1"
}

# move up specified number of direcotires
up() {
    declare -i x=$1
    local traverse

    [[ $1 ]] || { cd ..; return; } # default to 1 level
    (( x == 0 )) && return # noop

    while (( x-- )); do
        traverse+='../'
    done

    cd $traverse
}
