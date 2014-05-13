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

# find what package owns a given executable or file
pkgown() {
    DISTRIB_ID=$(grep '^DISTRIB_ID=' /etc/lsb-release | cut -d '=' -f 2)
    if [[ $1 =~ ^/ ]]; then
        file="$1"
    else
        file=$(which "$1")
    fi

    case "$DISTRIB_ID" in
        Arch)
            pacman -Qo "$file"
            ;;
        Ubuntu)
            dpkg -S "$file"
            ;;
    esac
}

# search for a package
pkgsearch() {
    DISTRIB_ID=$(grep '^DISTRIB_ID=' /etc/lsb-release | cut -d '=' -f 2)

    case "$DISTRIB_ID" in
        Arch)
            pacman -Ss "$1"
            meat -s "$1"
            ;;
        Ubuntu)
            apt-cache search "$1"
            ;;
    esac
}

# update packages
upgrade() {
    DISTRIB_ID=$(grep '^DISTRIB_ID=' /etc/lsb-release | cut -d '=' -f 2)

    case "$DISTRIB_ID" in
        Arch)
            if [ $(id -u) = "0" ]; then
                pacman -Syyu
                su -c "meat -u" michael
            else
                sudo pacman -Syyu
                meat -u
            fi
            ;;
        Ubuntu)
            if [ $(id -u) = "0" ]; then
                apt-get update && apt-get dist-upgrade
            else
                sudo apt-get update && sudo apt-get dist-upgrade
            fi
            ;;
    esac
}

# get installed packages
getinstalled() {
    DISTRIB_ID=$(grep '^DISTRIB_ID=' /etc/lsb-release | cut -d '=' -f 2)

    case "$DISTRIB_ID" in
        Arch)
            pacman -Q
            ;;
        Ubuntu)
            dpkg --get-selections | grep '\sinstall$'
            ;;
    esac
}

# get information about a packagae
pkginfo() {
    DISTRIB_ID=$(grep '^DISTRIB_ID=' /etc/lsb-release | cut -d '=' -f 2)

    case "$DISTRIB_ID" in
        Arch)
            pacman -Qi "$1" 2>/dev/null || pacman -Si "$1"
            ;;
        Ubuntu)
            apt-cache show "$1"
            ;;
    esac
}

pkgprovides() {
    DISTRIB_ID=$(grep '^DISTRIB_ID=' /etc/lsb-release | cut -d '=' -f 2)

    case "$DISTRIB_ID" in
        Arch)
            pkgfile "$1"
            ;;
        Ubuntu)
            apt-file search "$1"
            ;;
    esac
}
