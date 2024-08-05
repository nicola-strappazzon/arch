#!/usr/bin/env sh
set -eu

main() {
    platform="$(uname -s)"
    arch="$(uname -m)"
    pms=($(package_manager_system))

    echo "OS: ${platform}-${arch}"
    echo "Package manager: ${pms}"
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
