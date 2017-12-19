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
    if [ "$(uname)" = "Darwin" ]; then
        DISTRIB_ID='Darwin'
    elif [ -f /etc/redhat-release ]; then
        DISTRIB_ID='RHEL'
    else
        DISTRIB_ID=$(grep '^DISTRIB_ID=' /etc/lsb-release | cut -d '=' -f 2)
    fi

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
        RHEL)
            rpm -qf "$file" --queryformat '%{NAME}\n'
            ;;
        Darwin)
            path="$(readlink -f "$file")"
            if [[ "$path" =~ Cellar ]]; then
                echo "$path" | cut -d/ -f5
            fi
            ;;
    esac
}

# search for a package
pkgsearch() {
    if [ "$(uname)" = "Darwin" ]; then
        DISTRIB_ID='Darwin'
    elif [ -f /etc/redhat-release ]; then
        DISTRIB_ID='RHEL'
    else
        DISTRIB_ID=$(grep '^DISTRIB_ID=' /etc/lsb-release | cut -d '=' -f 2)
    fi

    case "$DISTRIB_ID" in
        Arch)
            pacman -Ss "$1"
            if [ $(id -u) = "0" ]; then
                su -P -c "trizen -Ss --aur \"$1\"" michael
            else
                trizen -Ss --aur "$1"
            fi
            ;;
        Ubuntu)
            apt-cache search "$1"
            ;;
        RHEL)
            yum search "$1"
            ;;
        Darwin)
            brew search "$1"
            ;;
    esac
}

# update packages
upgrade() {
    if [ "$(uname)" = "Darwin" ]; then
        DISTRIB_ID='Darwin'
    elif [ -f /etc/redhat-release ]; then
        DISTRIB_ID='RHEL'
    else
        DISTRIB_ID=$(grep '^DISTRIB_ID=' /etc/lsb-release | cut -d '=' -f 2)
    fi

    case "$DISTRIB_ID" in
        Arch)
            if [ $(id -u) = "0" ]; then
                pacman -Syyu
                su -P -c "trizen -Su --aur" michael
            else
                sudo pacman -Syyu
                trizen -Su --aur
            fi
            ;;
        Ubuntu)
            if [ $(id -u) = "0" ]; then
                apt-get update && apt-get dist-upgrade
            else
                sudo apt-get update && sudo apt-get dist-upgrade
            fi
            ;;
        RHEL)
            if [ $(id -u) = "0" ]; then
                yum update
            else
                sudo yum update
            fi
            ;;
        Darwin)
            brew upgrade
            ;;
    esac
}

# get installed packages
getinstalled() {
    if [ "$(uname)" = "Darwin" ]; then
        DISTRIB_ID='Darwin'
    elif [ -f /etc/redhat-release ]; then
        DISTRIB_ID='RHEL'
    else
        DISTRIB_ID=$(grep '^DISTRIB_ID=' /etc/lsb-release | cut -d '=' -f 2)
    fi

    case "$DISTRIB_ID" in
        Arch)
            pacman -Q
            ;;
        Ubuntu)
            dpkg --get-selections | grep '\sinstall$' | awk '{print $1}'
            ;;
        RHEL)
            yum list installed | awk '{print $1}'
            ;;
        Darwin)
            brew list
            ;;
    esac
}

# get information about a packagae
pkginfo() {
    if [ "$(uname)" = "Darwin" ]; then
        DISTRIB_ID='Darwin'
    elif [ -f /etc/redhat-release ]; then
        DISTRIB_ID='RHEL'
    else
        DISTRIB_ID=$(grep '^DISTRIB_ID=' /etc/lsb-release | cut -d '=' -f 2)
    fi

    case "$DISTRIB_ID" in
        Arch)
            if [ $(id -u) = "0" ]; then
                pacman -Qi "$1" 2>/dev/null || \
                    pacman -Si "$1" 2>/dev/null || \
                    su -P -c "trizen -Si --aur \"$1\"" michael
            else
                pacman -Qi "$1" 2>/dev/null || \
                    pacman -Si "$1" 2>/dev/null || \
                    trizen -Si --aur "$1"
            fi
            ;;
        Ubuntu)
            apt-cache show "$1"
            ;;
        RHEL)
            yum info "$1"
            ;;
        Darwin)
            brew info "$1"
            ;;
    esac
}

pkgprovides() {
    if [ "$(uname)" = "Darwin" ]; then
        DISTRIB_ID='Darwin'
    elif [ -f /etc/redhat-release ]; then
        DISTRIB_ID='RHEL'
    else
        DISTRIB_ID=$(grep '^DISTRIB_ID=' /etc/lsb-release | cut -d '=' -f 2)
    fi

    case "$DISTRIB_ID" in
        Arch)
            pkgfile "$1"
            ;;
        Ubuntu)
            apt-file search "$1"
            ;;
        RHEL)
            yum whatprovides "$1"
            ;;
        Darwin)
            echo "Function unimplemented on Darwin"
            ;;
    esac
}

pkglist() {
    if [ "$(uname)" = "Darwin" ]; then
        DISTRIB_ID='Darwin'
    elif [ -f /etc/redhat-release ]; then
        DISTRIB_ID='RHEL'
    else
        DISTRIB_ID=$(grep '^DISTRIB_ID=' /etc/lsb-release | cut -d '=' -f 2)
    fi

    case "$DISTRIB_ID" in
        Arch)
            pacman -Ql "$1"
            ;;
        Ubuntu)
            dpkg-query -L "$1"
            ;;
        RHEL)
            rpm -ql "$1"
            ;;
        Darwin)
            brew list "$1"
            ;;
    esac
}
