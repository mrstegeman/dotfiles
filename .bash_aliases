alias extract='bsdtar xf'

# make directory and change to it
mkcd() {
    [[ $1 ]] || return 0
    [[ ! -d $1 ]] && mkdir -p "$1"
    [[ -d $1 ]] && builtin cd "$1"
}

# move up specified number of directories
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
            if [ $(id -u) = "0" ]; then
                su -c "pacaur --sort name -s \"$1\"" michael
            else
                pacaur --sort name -s "$1"
            fi
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
                su -c "pacaur -u" michael
            else
                sudo pacman -Syyu
                pacaur -u
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
            dpkg --get-selections | grep '\sinstall$' | awk '{print $1}'
            ;;
    esac
}

# get information about a packagae
pkginfo() {
    DISTRIB_ID=$(grep '^DISTRIB_ID=' /etc/lsb-release | cut -d '=' -f 2)

    case "$DISTRIB_ID" in
        Arch)
            if [ $(id -u) = "0" ]; then
                pacman -Qi "$1" 2>/dev/null || \
                    pacman -Si "$1" 2>/dev/null || \
                    su -c "pacaur -i \"$1\"" michael
            else
                pacman -Qi "$1" 2>/dev/null || \
                    pacman -Si "$1" 2>/dev/null || \
                    pacaur -i "$1"
            fi
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

pkglist() {
    DISTRIB_ID=$(grep '^DISTRIB_ID=' /etc/lsb-release | cut -d '=' -f 2)

    case "$DISTRIB_ID" in
        Arch)
            pacman -Ql "$1"
            ;;
        Ubuntu)
            dpkg-query -L "$1"
            ;;
    esac
}
