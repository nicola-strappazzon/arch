#!/usr/bin/env sh
set -eu

main() {
    check_is_not_root
    platform="$(uname -s)"
    arch="$(uname -m)"
    pms=($(package_manager_system))

    echo "OS: ${platform}-${arch}"
    echo "Package manager: ${pms}"
}

check_is_not_root() {
    # Make sure are not root can run our script
    if [[ $EUID -eq 0 ]]; then
        echo "This script must be run as not root"
        exit 1
    fi
}

package_manager_system() {
    declare -A osInfo;

    osInfo[/etc/redhat-release]=yum
    osInfo[/etc/arch-release]=pacman
    osInfo[/etc/gentoo-release]=emerge
    osInfo[/etc/SuSE-release]=zypp
    osInfo[/etc/debian_version]=apt-get
    osInfo[/etc/alpine-release]=apk

    for f in ${!osInfo[@]}
    do
        if [[ -f $f ]];then
            echo "${osInfo[$f]}"
        fi
    done
}

main "$@"
