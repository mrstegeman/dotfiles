__get_os_type() {
    if [ "$(uname)" = "Darwin" ]; then
        echo 'Darwin'
    elif [ -f /etc/redhat-release ]; then
        echo 'RHEL'
    elif [ -f /etc/debian_version ]; then
        echo 'Debian'
    else
        DISTRIB_ID=$(lsb_release -is)
        if [ "$DISTRIB_ID" = "Ubuntu" ]; then
            echo 'Debian'
        fi

        echo "$DISTRIB_ID"
    fi
}

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
    if [[ $1 =~ ^/ ]]; then
        file="$1"
    else
        file=$(which "$1")
    fi

    case "$(__get_os_type)" in
        Arch)
            pacman -Qo "$file"
            ;;
        Debian)
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
    case "$(__get_os_type)" in
        Arch)
            pacman -Ss "$1"
            if [ $(id -u) = "0" ]; then
                su -P -c "trizen -Ss --aur \"$1\"" michael
            else
                trizen -Ss --aur "$1"
            fi
            ;;
        Debian)
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
    case "$(__get_os_type)" in
        Arch)
            if [ $(id -u) = "0" ]; then
                pacman -Syu
                su -P -c "trizen -Su --aur" michael
            else
                sudo pacman -Syu
                trizen -Su --aur
            fi
            ;;
        Debian)
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
    case "$(__get_os_type)" in
        Arch)
            pacman -Q
            ;;
        Debian)
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
    case "$(__get_os_type)" in
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
        Debian)
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
    case "$(__get_os_type)" in
        Arch)
            pkgfile "$1"
            ;;
        Debian)
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
    case "$(__get_os_type)" in
        Arch)
            pacman -Ql "$1"
            ;;
        Debian)
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

download_youtube() {
    fname_in=$(youtube-dl --get-filename "$1")
    fname_out="${fname_in/-[[:alnum:]]*.mp4/.mp4}"

    youtube-dl \
        --merge-output-format mp4 \
        --postprocessor-args '-strict -2' \
        "$1" || return 1
    ffmpeg \
        -i "${fname_in}" \
        -c:v copy \
        -c:a aac \
        -b:a 160k \
        "${fname_out}" || return 1
    rm -f "${fname_in}"
}
